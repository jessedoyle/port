require 'rails_helper'

describe 'routing to static pages' do
  it 'routes root_url to static#fetch' do
    expect(get: root_path).to route_to('static#fetch')
  end

  it 'routes / to static pages' do
    expect(get: '/').to route_to('static#fetch')
  end

  it 'routes static assets to static controller' do
    expect(get: 'assets/js/test.js').to route_to(
      controller: 'static',
      action: 'fetch',
      request: 'assets/js/test',
      format: 'js'
    )
  end

  it 'routes multi-directory requests to static controller' do
    expect(get: 'about/me/resume').to route_to(
      controller: 'static',
      action: 'fetch',
      request: 'about/me/resume'
    )
  end
end
