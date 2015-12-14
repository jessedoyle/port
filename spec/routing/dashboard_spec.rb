require 'rails_helper'

describe 'routing to admin dashboard' do
  it 'routes /dashboard to admin dashboard' do
    expect(get: 'dashboard').to route_to('dashboard#admin')
  end
end
