require 'pathname'

module Static
  class Pages
    attr_reader :root_path

    def initialize(opts = {})
      @root_path = opts[:root] ? Pathname.new(opts[:root]) : Static.root_path
    end

    def pages
      Dir[File.join(root_path, '**/*.{html,xml}')]
    end

    def root
      File.basename(root_path)
    end

    def persist!
      found, persisted = pages, Page.where(root: root)
      tap do
        create_new_pages(found, persisted)
        delete_old_pages(found, persisted)
      end
    end

    private

    def create_new_pages(pages_found, root_pages)
      paths = root_pages.map(&:absolute_path)
      diff = pages_found.select { |p| !paths.include?(p) }
      diff.each do |page|
        path = Pathname.new(page)
        Page.create({
          root: root,
          absolute_path: path,
          relative_path: path.relative_path_from(root_path)
        })
      end
    end

    def delete_old_pages(pages_found, root_pages)
      root_pages.each do |page|
        page.destroy unless pages_found.include?(page.absolute_path)
      end
    end
  end
end
