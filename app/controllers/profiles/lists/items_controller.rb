class Profiles::Lists::ItemsController < ApplicationController
  before_action :set_profile
  before_action :set_list
  before_action :set_list_item, only: %i[edit update destroy]

  # validate permissions to take actions on this list when current_session_scope is owner
  # or has permissions through :list_permissions, or if an admin is signed in
  before_action :redirect_no_permissions, unless: :item_action_permissions!, except: :create

  respond_to :html

  def edit; end

  def new
    @list_item = ListItem.new
  end

  def create
    @list_item = @list.list_items.build list_item_params
    @list_item.creator = current_session_scope

    flash_notice_with t('flash.list_item.create') if @list_item.save
    respond_with @list_item, location: [@profile, @list]
  end

  def update
    if @list_item.update list_item_params
      flash_notice_with t('flash.list_item.edit')
      respond_with @list_item, location: [@profile, @list]
    else
      respond_with @list_item, render: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list_item.destroy
    flash_notice_with t('flash.list_item.delete')
    respond_with @list_item, location: [@profile, @list]
  end

  protected

  def set_profile
    @profile = Profile.find params[:profile_id]
  end

  def set_list
    @list = @profile.owner.lists.find params[:list_id]
  end

  def set_list_item
    @list_item = @list.list_items.find params[:id]
  end

  def list_item_params
    params.require(:list_item).permit(:text)
  end

  def item_action_permissions!
    admin_signed_in? || current_session_scope && (@list.ownable == current_session_scope || @list_item.my_list_item?(current_session_scope))
  end

  def create_item_permissions!
    admin_signed_in? || current_session_scope && (@list.ownable == current_session_scope || current_session_scope.list_permissions?(@list))
  end
end
