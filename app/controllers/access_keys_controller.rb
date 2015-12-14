class AccessKeysController < ApplicationController
  before_action :authenticate_admin!, except: [:authorize, :unauthorized]
  before_action :set_key, only: [:edit, :update, :destroy]

  # POST /access_keys/:value/
  def authorize
    key = AccessKey.find_by(value: access_key_auth_params[:value].downcase)
    respond_to do |format|
      if key && key.not_expired?
        session[:access_key] = key.value
        previous = session.delete(:previous_url) || root_path
        format.html { redirect_to previous }
      else
        if key
          # must be expired/revoked
          flash.now[:alert] = 'Access code is expired.'
        else
          flash.now[:alert] = 'Invalid access code.'
        end

        format.html { access_denied }
      end
    end
  end

  def create
    @key = AccessKey.new(access_key_params)

    respond_to do |format|
      if @key.save
        format.html { redirect_to admin_dashboard_path, notice: 'Access code created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @key.destroy

    respond_to do |format|
      format.html { redirect_to admin_dashboard_path, notice: 'Access code deleted.' }
    end
  end

  def edit
  end

  def index
    @keys = AccessKey.all
  end

  def new
    @key = AccessKey.new
  end

  def update
    respond_to do |format|
      if @key.update(access_key_params)
        format.html { redirect_to admin_dashboard_path, notice: 'Access code updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private

  def access_key_auth_params
    params.require(:access_key).permit(:value)
  end

  def access_key_params
    params.require(:access_key).permit(:value, :expires_after)
  end

  def set_key
    @key = AccessKey.find(params[:id])
  end
end