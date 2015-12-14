require 'rails_helper'

describe StaticController do
  before do
    Static::Pages.new.persist!
  end

  describe 'fetch' do
    context 'not authorized' do
      it 'allows asset files to be sent' do
        get :fetch, request: 'assets/js/console', format: 'js'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/javascript')
      end

      it 'renders the access_denied action when not asset' do
        get :fetch, request: 'about'
        expect(response).to render_template(:unauthorized)
        expect(response).to render_template(layout: 'unauthorized')
        expect(response).to have_http_status(401)
      end

      it 'renders the 404 template when file is not found' do
        get :fetch, request: '__invalid__/something'
        errdoc = Rails.root.join('public', '404.html').to_s
        expect(response).to have_http_status(404)
        expect(response).to render_template(file: errdoc)
      end
    end

    context 'authorized' do
      before do
        @key = create(:access_key)
        session[:access_key] = @key.value
      end

      it 'allows asset files to be sent' do
        get :fetch, request: 'assets/css/test', format: 'css'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/css')
      end

      specify 'renders the html template requested' do
        root = File.join('spec', 'sites')
        controller.prepend_view_path(root)
        template = File.join('example', 'about', 'index.html').to_s
        get :fetch, request: 'about'
        expect(response).to have_http_status(200)
        expect(response).to render_template(template)
        expect(response).to render_template(layout: false)
        expect(response.content_type).to eq('text/html')
      end

      it 'renders the file when the format is not html' do
        get :fetch, request: 'feed', format: 'xml'
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/xml')
      end

      it 'renders the 404 template when the file is not found' do
        get :fetch, request: '__invalid__/something'
        errdoc = Rails.root.join('public', '404.html').to_s
        expect(response).to have_http_status(404)
        expect(response).to render_template(file: errdoc)
      end
    end
  end
end
