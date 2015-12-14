require 'rails_helper'

TestController = Class.new(ApplicationController)

describe ApplicationController do
  controller TestController do
    def unauthorized
      raise ApplicationController::AccessDenied
    end

    def not_found
      raise ApplicationController::FileNotFound
    end
  end

  specify 'access_denied renders the unauthorized layout' do
    routes.draw { get 'unauthorized' => 'test#unauthorized' }

    get :unauthorized
    expect(response).to render_template('unauthorized')
    expect(response).to render_template(layout: 'unauthorized')
    expect(response).to have_http_status(401)
    expect(assigns[:key]).to be_a_new(AccessKey)
    expect(session[:previous_url]).to eq('/unauthorized')
  end

  specify 'not_found! renders public/404.html' do
    errdoc = Rails.root.join('public', '404.html').to_s
    routes.draw { get 'not_found' => 'test#not_found' }

    get :not_found
    expect(response).to render_template(file: errdoc)
    expect(response).to have_http_status(404)
  end
end
