class Manage::Admins::ListsController < ApplicationController
  # require an admin to be signed in
  before_action :admin_signed_in!

  before_action :set_admin, except: :overview
  before_action :set_list, except: %i[index new create overview]

  respond_to :html

  # get lists of all admins
  # GET 'manage/admins/lists'
  def overview
    store_location!
    @lists = List.of_admins.order(created_at: :desc).all
  end

  # get lists by specific admin
  # GET 'manage/admins/:id/lists'
  def index
    store_location!
    @lists = List.of(@admin).order(created_at: :desc).all
  end

  def new
    @list = List.new
  end

  def update
    if @list.update list_params
      respond_with @list, location: session[:redirect_to], notice: t('administration.flash.list.edit')
    else
      respond_with @list, render: :edit
    end
  end

  def create
    @list = @admin.lists.build list_params

    # set the current admin for the creator of list
    @list.creator = current_admin

    if @list.save
      flash_notice_with t('administration.flash.list.create')
      respond_with @list, location: session[:redirect_to]
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

  def set_admin
    @admin = Admin.find params[:admin_id]
  end

  def set_list
    @list = List.find params[:id]
  end

  def list_params
    params.require(:list).permit(:name, :description)
  end
end
