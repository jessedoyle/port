class StaticController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :fetch
  before_action :authorize!, only: :fetch

  def fetch
    handler = Static::Handler.new(params)
    respond_to do |format|
      format.html { render handler.view, layout: false }
      format.any { send_file handler.file_path, type: handler.format, status: handler.status }
    end
  end
end
