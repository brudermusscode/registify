class Profiles::Lists::PermissionsController < ApplicationController
  before_action :set_profile
  before_action :set_list
  before_action :set_permission, only: :destroy

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :list_action_permissions!

  respond_to :html

  def index
    @permissions = @list.list_permissions.all
  end

  def destroy
    @permission.destroy
    flash_notice_with t('flash.list_permission.delete')
    respond_with @permission, location: [@profile, @list, :list_permissions]
  end

  protected

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = @profile.owner.lists.find params[:list_id]
  end

  def set_permission
    @permission = @list.list_permissions.find params[:id]
  end

  def list_action_permissions!
    admin_signed_in? || current_session_scope && (@profile.owner == current_session_scope || current_session_scope.list_permissions?(@list))
  end
end
