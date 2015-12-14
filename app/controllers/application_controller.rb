class ApplicationController < ActionController::Base
  AccessDenied = Class.new(StandardError)
  FileNotFound = Class.new(StandardError)

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from AccessDenied, with: :access_denied
  rescue_from FileNotFound, with: :not_found!

  def access_denied
    store_location

    @key = AccessKey.new
    @contact = Rails.configuration.x.port_contact_email

    respond_to do |format|
      format.html { render 'shared/unauthorized', status: 401, layout: 'unauthorized' }
    end
  end

  private

  def authorize!
    handler = Static::Handler.new(params)
    unless handler.asset? || admin_signed_in?
      page = Page.find_by(absolute_path: handler.file_path)
      raise FileNotFound unless page
      unless page.public?
        key = AccessKey.find_by(value: session[:access_key])
        if key.nil? || key.expired?
          raise AccessDenied
        end
      end
    end
  end

  def store_location
    if request.get? && !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def not_found!
    render file: Rails.root.join('public', '404.html'), status: 404, layout: false
  end
end
