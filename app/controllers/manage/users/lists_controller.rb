class Manage::Users::ListsController < ApplicationController
  # require an admin to be signed in
  before_action :admin_signed_in!

  before_action :set_user, except: :overview
  before_action :set_list, except: %i[index new create overview]

  respond_to :html

  # get all lists of users
  # GET 'manage/users/lists'
  # TODO: in users controller or own controller
  def overview
    store_location!
    @lists = List.of_users.order(created_at: :desc).all
  end

  # get all lists by specific user
  # GET 'manage/users/:id/lists'
  def index
    store_location!
    @lists = List.of(@user).order(created_at: :desc).all
  end

  def new
    @list = List.new
  end

  def edit; end

  def update
    if @list.update list_params
      redirect_to session[:redirect_to], notice: t('administration.flash.list.edit')
    else
      respond_with @list, render: :edit
    end
  end

  def create
    @list = @user.lists.build list_params

    # set the current admin for the creator of list
    @list.creator = current_admin

    if @list.save
      flash_notice_with t('administration.flash.list.create')
      respond_with @list, location: [:manage, @user, :lists]
    else
      respond_with @list, render: :new
    end
  end

  def destroy
    @list.destroy
    flash_notice_with t('administration.flash.list.delete')
    respond_with @list, location: session[:redirect_to]
  end

  protected

  def set_user
    @user = User.find params[:user_id]
  end

  def set_list
    @list = List.find params[:id]
  end

  def list_params
    params.require(:list).permit(:name, :description)
  end
end
