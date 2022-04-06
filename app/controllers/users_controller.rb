class UsersController < ApplicationController
  # preload the belonging user for certain actions
  before_action :assign_user, except: %i[index]

  # check if an admin is signed in
  before_action :admin_signed_in!

  # if user mail address gets updated through an admin, there is no need
  # to reconfirm that user
  before_action :no_need_for_reconfirmation, only: %i[update]

  # users can only be approved/activated, if they do have confirmed their
  # mail address through the given validation process method set in the devise
  # config
  before_action :user_confirmed!, only: :approve

  def index
    @users = User.all
  end

  def free
    if @user.free!
      flash_notice_with t('flash.user.free')
    else
      flash_alert_with t('flash.user.fail_free_needs_approve')
    end

    redirect_back fallback_location: users_path
  end

  def approve
    @user.toggle_active_state!

    if @user.activated?
      flash_notice_with(t('flash.user.activate'))
    else
      flash_notice_with(t('flash.user.deactivate'))
    end

    redirect_back fallback_location: users_path
  end

  def lock
    @user.unlock!
    flash_notice_with(t('flash.user.unlock'))

    redirect_back fallback_location: users_path
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: t('flash.user.edit')
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: t('flash.user.delete')
  end

  protected

  def no_need_for_reconfirmation
    @user.skip_reconfirmation!
  end

  def assign_user
    @user = User.find params[:id]
  end

  def user_confirmed!
    unless @user.confirmed?
      redirect_back fallback_location: users_path,
                    alert: t('administration.users.flash.fail.confirm')
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :born_at)
  end
end
