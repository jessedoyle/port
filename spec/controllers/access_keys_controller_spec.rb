require 'rails_helper'

describe AccessKeysController do
  context 'admin' do
    before do
      @admin = create(:admin)
      sign_in(@admin, scope: :admin)
    end

    describe 'create' do
      let(:access_key) { build(:access_key) }

      it 'redirects to the dashboard after creation' do
        post :create, access_key: { value: access_key.value, expires_after: access_key.expires_after }
        expect(response).to redirect_to(admin_dashboard_path)
      end

      it 'renders the new action (with errors) if access key is invalid' do
        key = build(:invalid_access_key)
        post :create, access_key: { value: key.value, expires_after: key.expires_after }
        errors = assigns[:key].errors

        expect(response).to render_template(:new)
        expect(errors.size).to eq(2)
      end
    end

    describe 'destroy' do
      before(:each) do
        @key = create(:access_key)
      end

      it 'destroys the access key with the given id' do
        proc = -> { delete :destroy, id: @key.id }
        expect(proc).to change(AccessKey, :count).by(-1)
      end

      it 'redirects to the admin dashboard' do
        delete :destroy, id: @key.id
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    describe 'edit' do
      before(:each) do
        @key = create(:access_key)
      end

      it 'renders the edit template' do
        get :edit, id: @key
        expect(response).to render_template(:edit)
      end
    end

    describe 'index' do
      it 'populates an array of all access keys' do
        3.times { create(:access_key) }
        get :index
        expect(assigns[:keys].size).to eq(3)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe 'new' do
      it 'assigns a new access key record' do
        get :new
        key = assigns[:key]
        expect(key.new_record?).to be_truthy
        expect(key).to be_a(AccessKey)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe 'update' do
      before(:each) do
        @key = create(:access_key)
      end

      it 'updates the attributes of the access key' do
        diff = build(:access_key)
        patch :update, id: @key.id, access_key: { value: diff.value }
        expect(assigns[:key].value).to eq(diff.value)
      end

      it 'redirects to admin dashboard on success' do
        diff = build(:access_key)
        patch :update, id: @key.id, access_key: { value: diff.value }
        expect(response).to redirect_to(admin_dashboard_path)
      end

      it 'renders the edit template on on error' do
        diff = build(:invalid_access_key)
        patch :update, id: @key.id, access_key: { value: diff.value }
        expect(response).to render_template('edit')
        expect(assigns[:key].errors.size).to eq(1)
      end
    end
  end

  describe 'authorize' do
    it 'downcases the user input (value)' do
      AccessKey.create(value: 'all_down_case', expires_after: Date.tomorrow)
      post :authorize, access_key: { value: 'ALL_DOWN_case' }
      expect(response).to redirect_to(root_path)
    end

    context 'with valid key' do
      it 'sets the session[:access_key] value' do
        key = create(:access_key)
        post :authorize, access_key: { value: key.value }
        expect(session[:access_key]).to eq(key.value)
      end

      it 'deletes the session[:previous_url] key' do
        session[:previous_url] = '/'
        key = create(:access_key)
        post :authorize, access_key: { value: key.value }
        expect(session[:previous_url]).to be_nil
      end

      it 'redirects to session[:previous_url]' do
        session[:previous_url] = '/about'
        key = create(:access_key)
        post :authorize, access_key: { value: key.value }
        expect(response).to redirect_to('/about')
      end

      it 'redirects to root_path if session[:previous_url] is nil' do
        key = create(:access_key)
        post :authorize, access_key: { value: key.value }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with expired key' do
      it 'renders the unauthorized template' do
        key = create(:expired_access_key)
        post :authorize, access_key: { value: key.value }
        expect(response).to render_template(:unauthorized)
        expect(response).to render_template(layout: 'unauthorized')
      end

      it 'sets the flash[:alert] value' do
        key = create(:expired_access_key)
        post :authorize, access_key: { value: key.value }
        expect(flash[:alert]).to match(/is expired/)
      end
    end

    context 'with invalid key' do
      it 'renders the unauthorized template' do
        post :authorize, access_key: { value: '_invalid_' }
        expect(response).to render_template(:unauthorized)
        expect(response).to render_template(layout: 'unauthorized')
      end

      it 'sets the flash[:alert] value' do
        post :authorize, access_key: { value: '__invalid__' }
        expect(flash[:alert]).to match(/invalid/i)
      end
    end
  end
end
