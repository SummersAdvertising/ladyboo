#encoding: utf-8
module Admin::CommunitiesHelper

  def list_edit_btn(current_community)
    
    if current_community.type == "PeditorCommunity"
      "#{link_to( '編輯' , edit_admin_community_path(current_community), class: "edit")  }".html_safe
    elsif current_community.type == "CustomizedCommunity"
      "#{link_to( '編輯', custom_edit_admin_community_path(current_community), class: "edit")  }".html_safe
    end
        
  end

  def list_edit_lnk(title, current_community)
    
    if current_community.type == "PeditorCommunity"
      "#{link_to( title , edit_admin_community_path(current_community))  }".html_safe
    elsif current_community.type == "CustomizedCommunity"
      "#{link_to( title , custom_edit_admin_community_path(current_community))  }".html_safe
    end
        
  end

  def is_set_top(is_top)
    if is_top < 999
      image_tag "/images/admin/up.png", title: "置頂"
    end
  end

end
