require 'rails_helper'

describe DashboardController do
  describe 'admin' do
    context 'not logged in' do
      it 'redirects to login page' do
        get :admin
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'logged in' do
      before do
        @admin = create(:admin)
        sign_in :admin, @admin
      end

      it 'renders the admin template' do
        get :admin
        expect(response).to render_template(:admin)
      end

      it 'scans the static directory for pages as before_action' do
        before = Page.all.size
        get :admin
        after = Page.all.size
        expect(before).to eq(0)
        expect(after > 0).to be_truthy
      end

      it 'sets assigns @pages and @keys' do
        3.times { create(:access_key) }
        get :admin
        expect(assigns[:pages].first).to be_a(Page)
        expect(assigns[:keys].size).to eq(3)
      end
    end
  end
end
