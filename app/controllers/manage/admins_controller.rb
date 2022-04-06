class Manage::AdminsController < ApplicationController
  # check for an admin to be signed in before taking any action
  before_action :admin_signed_in!

  # set the admin belonging to certain actions
  before_action :set_admin, except: %i[index new create]

  # one admin atleast should be available and therefore the last one in the list
  # cannot be destroyed
  before_action :require_last_admin, only: :destroy

  respond_to :html

  def index
    @admins = Admin.order(created_at: :desc).all
  end

  def show; end

  def new
    @admin = Admin.new
  end

  def edit; end

  def update
    if @admin.update admin_params
      flash_notice_with t('administration.flash.admin.edit')
      respond_with @admin, location: %i[manage admins]
    else
      respond_with @admin, render: :edit
    end
  end

  def create
    @admin = Admin.new admin_params

    if @admin.save
      flash_notice_with t('administration.flash.admin.create')
      respond_with @admin, location: %i[manage admins]
    else
      respond_with @admin, render: :new
    end
  end

  def destroy
    @admin.destroy
    if @admin == current_admin
      respond_with @admin, location: root_path, notice: t('administration.flash.admin.delete')
    else
      respond_with @admin, location: %i[manage admins], notice: t('administration.flash.admin.delete')
    end
  end

  protected

  def set_admin
    @admin = Admin.find params[:id]
  end

  def admin_params
    params.require(:admin).permit(:username, :firstname, :lastname, :email, :born_at, :street, :city, :postcode,
                                  :password, :password_confirmation)
  end
end
