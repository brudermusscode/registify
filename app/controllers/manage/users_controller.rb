class Manage::UsersController < ApplicationController
  # check if an admin is signed in
  before_action :admin_signed_in!

  # set the belonging user for specific actions
  before_action :set_user, except: %i[index new create]

  # if user mail address gets updated through an admin, there is no need
  # to reconfirm that user
  before_action :no_need_for_reconfirmation, only: %i[update]

  # users can only be approved/activated, if they do have confirmed their
  # mail address through the given validation process method set in the devise
  # config
  before_action :user_confirmed!, only: :approve

  respond_to :html

  def index
    @users = User.order(created_at: :desc).all
  end

  def new
    @user = User.new
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      redirect_to %i[manage users], notice: t('administration.flash.user.edit')
    else
      render :edit
    end
  end

  def create
    @user = user.new user_params

    # confirm, free and activate added user
    @user.skip_confirmation!
    @user.confirm
    @user.free!

    if @user.save
      flash_notice_with t('administration.flash.user.create')
      respond_with @user, location: %i[manage users]
    else
      respond_with @user, render: :new
    end
  end

  def destroy
    @user.destroy
    redirect_to %i[manage users], notice: t('administration.flash.user.delete')
  end

  def free
    if @user.free!
      flash_notice_with t('administration.flash.user.free')
    else
      flash_alert_with t('administration.flash.user.fail_free_needs_approve')
    end

    redirect_back fallback_location: %i[manage users]
  end

  def approve
    @user.toggle_active_state!

    if @user.activated?
      flash_notice_with(t('administration.flash.user.activate'))
    else
      flash_notice_with(t('administration.flash.user.deactivate'))
    end

    redirect_back fallback_location: %i[manage users]
  end

  def lock
    @user.unlock!
    flash_notice_with(t('administration.flash.user.unlock'))

    redirect_back fallback_location: %i[manage users]
  end

  protected

  def no_need_for_reconfirmation
    @user.skip_reconfirmation!
  end

  def user_confirmed!
    unless @user.confirmed?
      redirect_back fallback_location: [:users],
                    alert: t('administration.flash.user.fail_confirm')
    end
  end

  def set_user
    @user = user.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :born_at, :street, :postcode, :city,
                                 :firstname, :lastname)
  end
end
