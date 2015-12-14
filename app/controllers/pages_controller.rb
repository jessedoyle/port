class PagesController < ApplicationController
  before_action :authenticate_admin!

  # PATCH /pages/:page_id/toggle
  def toggle_visibility
    @page = Page.find(params[:page_id])
    @page.toggle_visibility!

    respond_to do |format|
      format.js
    end
  end
end
