module Static
  ROOT = Rails.root.join('app', 'views', 'static')
  ASSET_DIR = 'assets'

  def self.root_path
    found = Rails.configuration.x.static_root
    found == {} ? ROOT : found
  end

  class Handler
    attr_reader :format, :root_path

    def initialize(params, opts = {})
      html = Mime::Type.lookup_by_extension(:html)
      @extension = sanitize_filename(params[:format])
      @path = sanitize_filename(params[:request])
      @format = Mime::Type.lookup_by_extension(extension) || html
      @index = html? && (path.nil? || extension.nil?)
      @root_path = opts[:root] || Static.root_path
    end

    def asset?
      @path && @path.split('/').first == ASSET_DIR
    end

    def filename
      if index? && html?
        parts = [@path, 'index.html'].compact
        File.join(parts)
      else
        "#{@path}.#{@extension}"
      end
    end

    def file_path
      File.join(root_path, filename)
    end

    def html?
      @format.html?
    end

    def index?
      @index
    end

    def status
      valid? ? 200 : 404
    end

    def valid?
      File.exist?(file_path)
    end

    def view
      File.join(File.basename(root_path), filename)
    end

    private

    def extension; @extension end
    def path; @path end

    def sanitize_filename(filename)
      if filename.is_a?(String)
        filename.strip.tap do |name|
          # Strip out the non-ascii character
          name.gsub!(/[^0-9A-Za-z.\-\/]/, '_')
        end
      end
    end
  end
end