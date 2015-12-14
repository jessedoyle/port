require 'rails_helper'

describe 'static page rendering' do
  before do
    root = File.join('spec', 'sites')
    StaticController.prepend_view_path(root)
    Static::Pages.new.persist!
  end

  context 'admin logged in' do
    before do
      @admin = create(:admin)
      login_as(@admin, scope: :admin, run_callbacks: :false)
    end

    it 'renders a private html page' do
      static_page = Page.find_by(relative_path: 'index.html')
      static_page.toggle_visibility! if static_page.public?
      visit static_page.request
      expect(page.status_code).to eq(200)
      expect(current_path).to eq('/')
      expect(page).to have_content('example')
    end

    it 'renders a public html page' do
      static_page = Page.find_by(relative_path: 'projects/index.html')
      static_page.toggle_visibility! unless static_page.public?
      visit static_page.request
      expect(page).to have_content('This is a standard projects page')
      expect(page.status_code).to eq(200)
    end

    it 'raises ActionView::MissingTemplate on invalid path' do
      proc = -> { visit '___invalid___/___path___' }
      expect(proc).to raise_error(ActionView::MissingTemplate)
    end
  end

  context 'unauthorized' do
    it 'redirects to the unauthorized layout when visiting a private page' do
      static_page = Page.first
      expect(static_page.public?).to be_falsey
      visit static_page.request
      expect(page).to have_title('Access Code Required')
      expect(page).to have_content('page contains sensitive information')
      expect(page.status_code).to eq(401)
    end

    it 'renders a public html page' do
      static_page = Page.find_by(relative_path: 'about/index.html')
      static_page.toggle_visibility! unless static_page.public?
      visit static_page.request
      expect(page).to have_content('This is a standard about page')
      expect(page.status_code).to eq(200)
    end

    it 'renders a 404 page when not found' do
      visit '___invalid___/___path___'
      expect(page).to have_content('doesn\'t exist')
      expect(page.status_code).to eq(404)
    end
  end

  context 'authorized' do
    before do
      @key = create(:access_key)
      page.set_rack_session(access_key: @key.value)
    end

    it 'renders a private html page' do
      static_page = Page.find_by(relative_path: 'index.html')
      static_page.toggle_visibility! if static_page.public?
      visit static_page.request
      expect(page.status_code).to eq(200)
      expect(current_path).to eq('/')
      expect(page).to have_content('example')
    end

    it 'renders a public html page' do
      static_page = Page.find_by(relative_path: 'projects/index.html')
      static_page.toggle_visibility! unless static_page.public?
      visit static_page.request
      expect(page).to have_content('This is a standard projects page')
      expect(page.status_code).to eq(200)
    end

    it 'renders a 404 page when not found' do
      visit '___invalid___/___path___'
      expect(page).to have_content('doesn\'t exist')
      expect(page.status_code).to eq(404)
    end
  end
end
