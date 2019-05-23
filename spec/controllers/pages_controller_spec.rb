require 'rails_helper'

describe PagesController do
  describe 'toggle_visibility' do
    context 'not logged in' do
      it 'redirects to login page' do
        page = create(:page)
        patch :toggle_visibility, page_id: page.id
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context 'logged in' do
      before do
        @admin = create(:admin)
        sign_in(@admin, scope: :admin)
      end

      it 'renders the toggle visibility javascript' do
        page = create(:page)
        patch :toggle_visibility, page_id: page.id, format: :js
        expect(response).to render_template('toggle_visibility', format: :js)
      end

      it 'toggles the page\'s visibility' do
        page = create(:page)
        before = page.public
        patch :toggle_visibility, page_id: page.id, format: :js
        expect(assigns[:page].public).to eq(!before)
      end
    end
  end
end
