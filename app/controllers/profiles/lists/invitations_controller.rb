class Profiles::Lists::InvitationsController < ApplicationController
  before_action :set_profile, except: :show
  before_action :set_list, except: :show
  before_action :set_invitation, only: %i[destroy accept]

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :list_action_permissions!, except: %i[show accept]

  # check for valid token in invitation link and for any scope to be logged in
  # otherwise redirect back
  before_action :invitation_valid?, only: :show

  respond_to :html

  def index
    @invitations = @list.list_invitations.order(use_count: :desc).all
  end

  def show
    store_location!
    @invitation = ListInvitation.find_by(token: params[:token])
  end

  def create
    @invitation = @list.list_invitations.build list_invitation_params

    if @invitation.save
      flash_notice_with "#{request.base_url}/inv/#{@invitation.token}"
    else
      flash_alert_with t('flash.list_invitation.fail_create')
    end

    respond_with @invitation, location: session[:redirect_to]
  end

  def destroy
    @invitation.destroy
    flash_notice_with t('flash.list_invitation.delete')
    respond_with @invitation, location: [@profile, @list, :list_invitations]
  end

  # if an invitation gets accepted by current_session_scope, new permissions for the related
  # list will be created. Checks for an invitation been accepted already
  def accept
    if @invitation.already_taken?(current_session_scope)
      flash_alert_with t('flash.list_invitation.already_taken')
      respond_with @invitation, location: session[:redirect_to]
    else
      @permission = current_session_scope.list_permissions.build permission_params
      @permission.list = @list

      if @permission.save
        @invitation.touch
        flash_notice_with t('flash.list_invitation.accept')
        respond_with @permission, location: [@profile, @list]
      else
        flash_notice_with t('flash.list_invitation.fail_accept')
        respond_with @permission, location: [@invitation]
      end
    end
  end

  protected

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = @profile.owner.lists.find params[:list_id]
  end

  def set_invitation
    @invitation = @list.list_invitations.find(params[:id])
  end

  def list_invitation_params
    params.require(:list_invitation).permit(:list_id)
  end

  def permission_params
    params.require(:list_permission).permit(:list_id)
  end

  def list_action_permissions!
    admin_signed_in? || current_session_scope && (@profile.owner == current_session_scope || current_session_scope.list_permissions?(@list))
  end

  def invitation_valid?
    redirect_to root_path unless current_session_scope && ListInvitation.find_by(token: params[:token])
  end
end
