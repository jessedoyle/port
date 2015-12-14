require 'rails_helper'

describe 'admin dashboard usage' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin, run_callbacks: :false)
  end

  describe 'static pages' do
    it 'populates a list of all static pages found' do
      visit admin_dashboard_path
      expect(page).to have_content('Pages')
      within('.static-pages') do
        expect(page).to have_selector('tr', count: Page.all.size)
      end
    end

    it 'makes a private page public', js: true do
      visit admin_dashboard_path
      static_page = Page.first
      expect(static_page.public?).to be_falsey
      row = page.find(".static-pages > tbody > tr[data-page-id=\"#{static_page.id}\"]")
      within(row) do
        click_link('Make Public')
      end
      expect(row).to have_content('Public')
      expect(row).to have_content('Make Private')
      expect(static_page.reload.public?).to be_truthy
    end

    it 'makes a public page private', js: true do
      Static::Pages.new.persist!
      static_page = Page.last
      static_page.toggle_visibility!
      expect(static_page.reload.public?).to be_truthy
      visit admin_dashboard_path
      row = page.find(".static-pages > tbody > tr[data-page-id=\"#{static_page.id}\"]")
      within(row) do
        click_link('Make Private')
      end
      expect(row).to have_content('Private')
      expect(row).to have_content('Make Public')
      expect(static_page.reload.public?).to be_falsey
    end
  end

  describe 'access codes' do
    it 'populates a list of all access keys found' do
      3.times { create(:access_key) }
      visit admin_dashboard_path
      expect(page).to have_content('Access Codes')
      within('.access-keys') do
        expect(page).to have_selector('tr', count: 3)
      end
    end

    it 'displays text if no access codes are found' do
      visit admin_dashboard_path
      within('.access-keys') do
        expect(page).to have_selector('tr', count: 1)
        row = page.find('tbody > tr')
        expect(row).to have_content('There are no access codes')
      end
    end

    it 'creates a new access code' do
      key = build(:access_key)
      visit admin_dashboard_path
      click_link('New Access Code')
      expect(current_path).to eq(new_access_key_path)
      within('#new_access_key') do
        fill_in 'access_key_value', with: key.value
        fill_in 'access_key_expires_after', with: key.expires_after
        click_button('Submit')
      end
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content('Access code created')
      within('.access-keys') do
        expect(page).to have_selector('tr', count: 1)
        row = page.find('tbody > tr')
        expect(row).to have_content(key.value)
      end
    end

    it 'edits an access code' do
      key = create(:access_key)
      visit admin_dashboard_path
      within('.access-keys > tbody > tr:first') do
        click_link('Edit')
      end
      expect(current_path).to eq(edit_access_key_path(key))
      within('.edit_access_key') do
        fill_in 'access_key_value', with: key.value + "somethingelse"
        fill_in 'access_key_expires_after', with: key.expires_after
        click_button('Submit')
      end
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content('Access code updated')
    end

    it 'deletes an access code' do
      key = create(:access_key)
      visit admin_dashboard_path
      within('.access-keys > tbody > tr:first') do
        click_link('Delete')
      end
      expect(page).to have_content('Access code deleted')
      expect(current_path).to eq(admin_dashboard_path)
      expect(AccessKey.exists?(key.id)).to be_falsey
    end
  end
end
