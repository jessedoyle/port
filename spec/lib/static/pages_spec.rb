require 'rails_helper'

describe Static::Pages do
  describe 'initialize' do
    it 'creates a Static::Pages instance, accepting a site path' do
      pages = Static::Pages.new(root: EXAMPLE_PATH)

      expect(pages).to be_a(Static::Pages)
    end
  end

  describe 'pages' do
    it 'finds all html/xml files within a directory (recursively)' do
      pages = Static::Pages.new(root: EXAMPLE_PATH).pages.sort

      expect(pages.size).to eq(5)
      expect(pages.first).to match(/about\/index.html/)
      expect(pages.last).to match(/index\.html/)
    end

    it 'returns an empty array when no files are found' do
      pages = Static::Pages.new(root: 'somewhere').pages.sort

      expect(pages.empty?).to be_truthy
    end
  end

  describe 'root' do
    it 'returns the basename of the root path' do
      pages = Static::Pages.new(root: EXAMPLE_PATH)
      base = File.basename(pages.root_path)

      expect(pages.root).to eq(base)
    end
  end

  describe 'persist!' do
    it 'creates a ActiveRecord::Page object for each page found' do
      pages = Static::Pages.new(root: EXAMPLE_PATH)
      pages.persist!
      db_pages = Page.all

      relative = db_pages.map(&:relative_path).select do |p|
        p =~ /[index\.html,feed\.xml]/
      end

      expect(db_pages.size).to eq(5)
      expect(relative.size).to eq(5)
    end

    it 'keeps pages in the db up to date with the filesystem' do
      new_page = File.join(EXAMPLE_PATH, 'test.html')
      pages = Static::Pages.new(root: EXAMPLE_PATH)
      pages.persist!
      initial = Page.all.size

      File.open(new_page, 'w') do |f|
        f.write('<!DOCTYPE html><title>x</title>')
      end

      pages.persist!
      middle = Page.all.size

      File.delete(new_page)

      pages.persist!
      final = Page.all.size

      expect(initial).to eq(5)
      expect(middle).to eq(6)
      expect(final).to eq(5)
    end

    it 'returns self' do
      pages = Static::Pages.new(root: EXAMPLE_PATH)
      ret = pages.persist!

      expect(ret).to be_a(Static::Pages)
    end
  end
end
