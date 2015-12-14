require 'rails_helper'

describe Static::Handler do
  let(:asset_params) { { format: 'css', request: 'assets/test' } }
  let(:html_params) { { request: 'test' } }
  let(:nil_params) { { format: 'html', request: nil } }

  describe 'initialize' do
    it 'creates a new handler instance' do
      handler = Static::Handler.new(html_params)

      expect(handler).to be_a(Static::Handler)
    end

    it 'has a customizable root path' do
      handler = Static::Handler.new(html_params, root: '/usr/share')

      expect(handler.root_path).to eq('/usr/share')
    end
  end

  describe 'asset?' do
    it 'returns true when the request is in the assets directory' do
      handler = Static::Handler.new(asset_params)

      expect(handler.asset?).to be_truthy
    end

    it 'returns false when request is not it the assets directory' do
      handler = Static::Handler.new(html_params)

      expect(handler.asset?).to be_falsey
    end

    it 'returns false when the request is nil' do
      handler = Static::Handler.new(nil_params)

      expect(handler.asset?).to be_falsey
    end
  end

  describe 'filename' do
    it 'returns the (relative) filename for the provided request' do
      handler = Static::Handler.new(asset_params)

      expect(handler.filename).to eq('assets/test.css')
    end

    it 'appends ...index.html if the request requires an index' do
      handler = Static::Handler.new(html_params)

      expect(handler.filename).to eq('test/index.html')
    end

    it 'returns index.html for a nil request (root_url)' do
      handler = Static::Handler.new(nil_params)

      expect(handler.filename).to eq('index.html')
    end
  end

  describe 'file_path' do
    it 'returns the filename joined with the root_path' do
      handler = Static::Handler.new(html_params)
      base = handler.root_path
      file = handler.filename

      expect(handler.file_path).to eq(File.join(base, file))
    end

    it 'works when the root_path directory is supplied' do
      handler = Static::Handler.new(html_params, root: EXAMPLE_PATH)
      base = handler.root_path
      file = handler.filename

      expect(handler.file_path).to eq(File.join(base, file))
    end
  end

  describe 'html?' do
    it 'defaults to true when params[:format] is nil' do
      params = { request: 'something' }
      handler = Static::Handler.new(params)

      expect(handler.html?).to be_truthy
    end

    it 'returns false when the format is not html' do
      handler = Static::Handler.new(asset_params)

      expect(handler.html?).to be_falsey
    end
  end

  describe 'index?' do
    it 'returns true when the requested path is an index' do
      handler = Static::Handler.new(html_params)

      expect(handler.index?).to be_truthy
    end

    it 'returns false when the requested path is not an index' do
      handler = Static::Handler.new(asset_params)

      expect(handler.index?).to be_falsey
    end

    it 'returns true when the request is nil (root url)' do
      handler = Static::Handler.new(nil_params)

      expect(handler.index?).to be_truthy
    end
  end

  describe 'status' do
    it 'gives an http/200 status when file is found' do
      # spec/sites/example/index.html
      handler = Static::Handler.new(nil_params, root: EXAMPLE_PATH)

      expect(handler.status).to eq(200)
    end

    it 'gives an http/404 status when file is not found' do
      # spec/sites/example/__invalid__.html
      params = { format: 'html', request: '__invalid__' }
      handler = Static::Handler.new(params, root: EXAMPLE_PATH)

      expect(handler.status).to eq(404)
    end
  end

  describe 'valid?' do
    it 'returns true when a matching file exists in filesystem' do
      # spec/sites/example/index.html
      handler = Static::Handler.new(nil_params, root: EXAMPLE_PATH)

      expect(handler.valid?).to be_truthy
    end

    it 'returns false when a file is not found in filesystem' do
      # spec/sites/example/__invalid__.html
      params = { format: 'html', request: '__invalid__' }
      handler = Static::Handler.new(params, root: EXAMPLE_PATH)

      expect(handler.valid?).to be_falsey
    end
  end

  describe 'view' do
    it 'returns the rails view path for the given request' do
      # spec/sites/example/index.html
      handler = Static::Handler.new(nil_params, root: EXAMPLE_PATH)

      expect(handler.view).to eq('example/index.html')
    end
  end

  describe 'sanitize_filename' do
    it 'converts invalid characters to underscores' do
      params = { format: 'html', request: '%invalid+$@\:' }
      handler = Static::Handler.new(params)

      expect(handler.filename).to eq('_invalid_____.html')
    end
  end
end
