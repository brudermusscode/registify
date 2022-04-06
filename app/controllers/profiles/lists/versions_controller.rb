class Profiles::Lists::VersionsController < ApplicationController
  before_action :set_profile
  before_action :set_list

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :list_action_permissions!

  def index
    @versions = @list.versions.reverse_order.all
  end

  protected

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = List.find params[:list_id]
  end

  def list_action_permissions!
    admin_signed_in? || current_session_scope && (@profile.owner == current_session_scope || current_session_scope.list_permissions?(@list))
  end
end
