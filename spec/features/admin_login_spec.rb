require 'rails_helper'

describe 'the admin login process' do
  let(:admin) { create(:admin) }

  it 'signs an admin in to the application' do
    sign_in_admin(admin)
  end

  it 'signs the admin out of the application' do
    sign_in_admin(admin)
    sign_out_admin(admin)
  end
end
