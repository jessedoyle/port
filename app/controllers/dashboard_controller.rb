class DashboardController < ApplicationController
  before_action :authenticate_admin!
  before_action :scan_static, only: :admin

  def admin
    @pages = Page.all
    @keys = AccessKey.all
  end

  private

  def scan_static
    @handler = Static::Pages.new
    @handler.persist!
  end
end
