class Page < ActiveRecord::Base
  validates_presence_of :absolute_path, :relative_path, :root
  validates_uniqueness_of :absolute_path

  def name
    normalize_request.prepend('/')
  end

  def other_visibility
    public ? 'Private' : 'Public'
  end

  def public?
    public
  end

  def request
    (normalize_request << '/').tap do |path|
      # turn into an absolute url
      path.prepend('/') unless path == '/'
    end
  end

  def toggle_visibility!
    toggle(:public).save
  end

  def visibility
    public ? 'Public' : 'Private'
  end

  private

  def normalize_request
    parts = relative_path.split('/')
    parts.pop if parts.last == 'index.html'
    parts.join('/')
  end
end
