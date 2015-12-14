require 'rails_helper'

describe 'static page authorization' do
  before do
    root = File.join('spec', 'sites')
    StaticController.prepend_view_path(root)
    Static::Pages.new.persist!
  end

  it 'allows a user with a valid access code to authorize' do
    key = create(:access_key)
    static_page = Page.find_by(relative_path: 'index.html')
    static_page.toggle_visibility! if static_page.public?
    visit static_page.request
    expect(page.status_code).to eq(401)
    within('.access-key-wrapper') do
      fill_in 'access_key_value', with: key.value
      click_button('Submit')
    end
    expect(page.status_code).to eq(200)
    expect(current_path).to eq(static_page.name)
    expect(page).to have_content('example')
  end

  it 'does not authorize an expired access code' do
    key = create(:expired_access_key)
    static_page = Page.find_by(relative_path: 'index.html')
    static_page.toggle_visibility! if static_page.public?
    visit static_page.request
    expect(page.status_code).to eq(401)
    within('.access-key-wrapper') do
      fill_in 'access_key_value', with: key.value
      click_button('Submit')
    end
    expect(page.status_code).to eq(401)
    expect(page).to have_content('expired')
  end

  it 'does not authorize an invalid access code' do
    # don't store an access key
    static_page = Page.find_by(relative_path: 'index.html')
    static_page.toggle_visibility! if static_page.public?
    visit static_page.request
    expect(page.status_code).to eq(401)
    within('.access-key-wrapper') do
      fill_in 'access_key_value', with: '__invalid__'
      click_button('Submit')
    end
    expect(page.status_code).to eq(401)
    expect(page).to have_content('Invalid')
  end
end
