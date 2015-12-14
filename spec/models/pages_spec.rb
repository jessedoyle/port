require 'rails_helper'

describe Page do
  describe 'initialize' do
    it 'validates the presence_of absolute_path' do
      page = Page.new(root: 'test', relative_path: 'a/b/c')
      expect(page.valid?).to be_falsey
      expect(page.errors.first).to eq([:absolute_path, 'can\'t be blank'])
      expect(page.errors.size).to eq(1)
    end

    it 'validates the presence_of root' do
      page = Page.new(absolute_path: '/root/a/b/c', relative_path: 'a/b/c')
      expect(page.valid?).to be_falsey
      expect(page.errors.first).to eq([:root, 'can\'t be blank'])
      expect(page.errors.size).to eq(1)
    end

    it 'validates the presence_of relative_path' do
      page = Page.new(absolute_path: '/root/a/b/c', root: 'test')
      expect(page.valid?).to be_falsey
      expect(page.errors.first).to eq([:relative_path, 'can\'t be blank'])
      expect(page.errors.size).to eq(1)
    end

    it 'validates the uniqueness_of absolute_path' do
      attrs = { absolute_path: '/a/b', relative_path: 'b', root: 'a' }
      Page.create(attrs)
      page = Page.new(attrs)
      expect(page.valid?).to be_falsey
      expect(page.errors.first).to eq([:absolute_path, 'has already been taken'])
      expect(page.errors.size).to eq(1)
    end

    it 'creates valid instances' do
      page = create(:page)
      expect(page).to be_valid
      expect(page).to be_a(Page)
      expect(page.new_record?).to be_falsey
    end

    it 'defaults the visiblity to private' do
      page = Page.create(absolute_path: '/a/b', relative_path: 'b', root: 'a')
      expect(page.public).to be_falsey
    end
  end

  describe 'name' do
    it 'strips index.html from the end' do
      page = create(:page_with_index)
      expect(page.name).to_not match(/index\.html/i)
    end

    it 'prepends a / character to the relatve_path' do
      page = create(:page)
      expect(page.name.start_with?('/')).to be_truthy
    end

    it 'returns a user-readable name' do
      page = create(:page_with_index)
      expect(page.name).to eq('/path')
    end
  end

  describe 'other_visibility' do
    it 'returns Public when visibility is private' do
      page = create(:page)
      expect(page.other_visibility).to eq('Public')
    end

    it 'returns Private when visibility is public' do
      page = create(:page)
      page.toggle_visibility!
      expect(page.other_visibility).to eq('Private')
    end
  end

  describe 'public?' do
    it 'returns true when public' do
      page = create(:page)
      page.toggle_visibility!
      expect(page.public?).to be_truthy
    end

    it 'returns false when private' do
      page = create(:page)
      expect(page.public?).to be_falsey
    end
  end

  describe 'request' do
    it 'appends a / character' do
      page = create(:page)
      expect(page.request.end_with?('/')).to be_truthy
    end

    it 'prepends a / character' do
      page = create(:page)
      expect(page.request.start_with?('/')).to be_truthy
    end

    it 'doesn\'t prepend a / on index.html (root)' do
      page = Page.create(absolute_path: '/test/index.html', relative_path: 'index.html', root: 'test')
      expect(page.request).to eq('/')
    end
  end

  describe 'toggle_visibility!' do
    it 'saves the record after toggling the visibility' do
      page = create(:page)
      vis = page.public
      page.toggle_visibility!
      expect(page.public).to eq(!vis)
    end
  end

  describe 'visibility' do
    it 'returns Private when visibility is private' do
      page = create(:page)
      expect(page.visibility).to eq('Private')
    end

    it 'returns Public when visibility is public' do
      page = create(:page)
      page.toggle_visibility!
      expect(page.visibility).to eq('Public')
    end
  end
end
