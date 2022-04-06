module ListsHelper
  def link_for(list, type)
    case type
    when 'owner'
      if list.ownable.instance_of?(Admin)
        link_to(list.ownable.username, [list.ownable.profile])
      else
        link_to(list.ownable.email, [list.ownable.profile])
      end
    when 'creator'
      if list.creator.instance_of?(Admin)
        link_to(list.creator.username, [list.creator.profile])
      else
        link_to(list.creator.email, [list.creator.profile])
      end
    end
  end
end
