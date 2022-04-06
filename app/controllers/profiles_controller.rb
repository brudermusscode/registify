class ProfilesController < ApplicationController
  before_action :set_profile

  # redirect to root path if no scope is logged in
  before_action :redirect_no_permissions, unless: :current_session_scope

  def show
    store_location!
  end

  protected

  def set_profile
    @profile = Profile.find params[:id]
  end
end
