class Profiles::Lists::RequestsController < ApplicationController
  before_action :set_profile
  before_action :set_list
  before_action :set_request, only: %i[destroy accept]

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :list_action_permissions!, except: %i[create destroy]

  respond_to :html

  def index
    store_location!
    @list_requests = @list.list_requests.all
  end

  def create
    @request = @list.list_requests.build request_params
    @request.requester = current_session_scope

    if @request.save
      flash_notice_with t('flash.list_request.create')
    else
      flash_alert_with t('flash.list_request.fail_create')
    end

    respond_with @request, location: session[:redirect_to]
  end

  def destroy
    @request.destroy
    flash_notice_with t('flash.list_request.delete')
    respond_with @request, location: session[:redirect_to]
  end

  # by accepting the request, new permissions for this list will be created
  # with the requester of the request, being the operator of the permissions
  # POST 'profiles/:profile_id/lists/:list_id/requests/:id/accept'
  def accept
    @permission = @request.requester.list_permissions.build permission_params
    @permission.list = @list

    if @permission.save
      flash_notice_with t('flash.list_request.accept')
    else
      flash_notice_with t('flash.list_request.fail_accept')
    end

    respond_with @request, location: session[:redirect_to]
  end

  protected

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = @profile.owner.lists.find params[:list_id]
  end

  def set_request
    @request = @list.list_requests.find params[:id]
  end

  def request_params
    params.require(:list_request).permit(:list_id)
  end

  def permission_params
    params.require(:list_permission).permit(:list_id)
  end

  def list_action_permissions!
    admin_signed_in? || current_session_scope && (@profile.owner == current_session_scope || current_session_scope.list_permissions?(@list))
  end
end
