class AdminsController < ApplicationController
  before_action :admin_signed_in!
  before_action :all_admins, only: :index
  before_action :assign_admin, except: :index
  before_action :require_last_admin, only: :destroy

  def index; end

  def new
    @admin = Admin.new
  end

  def edit; end

  def update
    if @admin.update(admin_params)
      redirect_to admins_path, notice: I18n.t('administration.admins.flash.success.edit')
    else
      redirect_back fallback_location: admins_path, alert: I18n.t('administration.admins.flash.fail.edit')
    end
  end

  def destroy
    @admin.destroy

    if @admin == current_admin
      redirect_to root_path, notice: t('flash.admin.delete')
    else
      redirect_to admins_path, notice: t('flash.admin.delete')
    end
  end

  def lists
    @lists = List.order(:updated_at).reverse_order.all
  end

  protected

  def assign_admin
    @admin = Admin.find params[:id]
  end

  def all_admins
    @admins = Admin.all
  end

  def admin_params
    params.require(:admin).permit(:username, :firstname, :lastname, :email, :born_at, :street, :postcode, :city,
                                  :password, :password_confirmation)
  end
end
