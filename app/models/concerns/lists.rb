# frozen_string_literal: true

module Lists
  extend ActiveSupport::Concern

  included do
    has_many :lists, as: :ownable, dependent: :destroy
    has_many :list_items, as: :creator
    has_many :list_permissions, as: :operator, dependent: :destroy
    has_many :list_requests, as: :requester, dependent: :destroy

    # trash unused data on destroy
    before_destroy :make_owner_the_creator_for_lists
    before_destroy :make_owner_the_creator_for_list_versions

    # detroy only list items of own lists and keep those posted to foreign lists, and [...]
    before_destroy :erase_list_items_of_own_lists

    # [...] change the creator of list items in foreign lists to the owner of the actual list owner
    before_destroy :change_creator_of_list_items_in_foreign_lists
  end

  # get all lists with permissions where self is not the owner
  def lists_with_permissions
    list_permissions.eager_load(:list).where.not(list: [lists]).map(&:list)
  end

  # check for list permissions on a specific list by passing the list object
  def list_permissions?(list_obj)
    list_permissions.find_by(list: list_obj).present?
  end

  def make_owner_the_creator_for_lists
    List.where(creator: self).each do |list|
      @list_owner = list.ownable
      list.update(creator: @list_owner)
    end
  end

  def make_owner_the_creator_for_list_versions
    ListVersion.where(whodunnit: to_global_id.to_s).update(whodunnit: 'N/A')
  end

  # only destroy list items of own lists, not those in foreign lists
  def erase_list_items_of_own_lists
    lists.each do |l|
      l.list_items.destroy_all
    end
  end

  # to avoid any exception raised through missing associated objects for list items in foreign lists,
  # change the creator of the list item to the actual owner of the items' list
  def change_creator_of_list_items_in_foreign_lists
    # search through all list items which do not belong to lists of self
    list_items.where.not(list: [lists]).each do |list_item|
      # take the owner of the list, which the list item belongs to
      @list_owner = list_item.list.ownable

      # and update the owner of the list item from self to the owner of the list
      list_item.update(creator: @list_owner)
    end
  end
end
