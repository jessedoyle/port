require 'rails_helper'

describe 'routing for static pages' do
  it 'routes PATCH /pages/:page_id/toggle to toggle_visibility' do
    expect(patch: 'pages/1/toggle').to route_to(
      controller: 'pages',
      action: 'toggle_visibility',
      page_id: '1'
    )
  end
end
