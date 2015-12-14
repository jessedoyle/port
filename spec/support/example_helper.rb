TEST_SITES_PATH = Rails.root.join('spec', 'sites')
EXAMPLE_PATH = File.join(TEST_SITES_PATH, 'example')
EXAMPLE_PAGE_COUNT = Static::Pages.new(root: EXAMPLE_PATH).pages.size
