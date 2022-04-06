class Profiles::ListsController < ApplicationController
  before_action :set_profile
  before_action :set_list, except: %i[index new create]
  before_action :set_list_items, only: :show

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :list_action_permissions!, except: :index

  respond_to :html

  def index
    store_location!
    @lists = @profile.owner.lists.order_by_updates.all
  end

  def show
    store_location!
    @list_item = ListItem.new
    @list_items = @list.list_items.order_by_updates.all
    @subscribers = @list.list_permissions.where.not(operator: @list.ownable).reverse_order.all
  end

  def new
    @list = List.new
  end

  def edit; end

  def create
    @list = @profile.owner.lists.build list_params
    @list.creator = current_session_scope

    if @list.save
      flash_notice_with t('flash.list.create')
      respond_with @list, location: [@profile, @list]
    else
      respond_with @list, render: :new, status: :unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      flash_notice_with t('flash.list.edit')
      respond_with @list, location: session[:redirect_to]
    else
      respond_with @list, render: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    flash_notice_with t('flash.list.delete')
    respond_with @list, location: [@profile]
  end

  private

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = @profile.owner.lists.find params[:id]
  end

  def set_list_items
    @list_items = @list.list_items
  end

  def list_params
    params.require(:list).permit(:name, :description)
  end

  def list_action_permissions!
    admin_signed_in? || current_session_scope && (@profile.owner == current_session_scope || current_session_scope.list_permissions?(@list))
  end
end
