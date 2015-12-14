require 'rails_helper'

describe 'routing to access keys' do
  it 'routes /access_keys to index' do
    expect(get: 'access_keys').to route_to('access_keys#index')
  end

  it 'routes POST /access_keys to create' do
    expect(post: 'access_keys').to route_to('access_keys#create')
  end

  it 'routes GET /access_keys/new to new' do
    expect(get: 'access_keys/new').to route_to('access_keys#new')
  end

  it 'routes GET /access_keys/:id/edit to edit' do
    expect(get: 'access_keys/1/edit').to route_to(
      controller: 'access_keys',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes PATCH /access_keys/:id to update' do
    expect(patch: 'access_keys/1').to route_to(
      controller: 'access_keys',
      action: 'update',
      id: '1'
    )
  end

  it 'routes PUT /access_keys/:id to update' do
    expect(put: 'access_keys/1').to route_to(
      controller: 'access_keys',
      action: 'update',
      id: '1'
    )
  end

  it 'routes DELETE /access_keys/:id to destroy' do
    expect(delete: 'access_keys/1').to route_to(
      controller: 'access_keys',
      action: 'destroy',
      id: '1'
    )
  end

  it 'routes POST /authorize to authorize' do
    expect(post: 'authorize').to route_to(
      controller: 'access_keys',
      action: 'authorize'
    )
  end

  it 'does not have a show action' do
    # The static catch-all should take over
    expect(get: 'access_keys/1').to route_to(
      controller: 'static',
      action: 'fetch',
      request: 'access_keys/1'
    )
  end
end
