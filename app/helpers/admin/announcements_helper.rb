#encoding: utf-8
module Admin::AnnouncementsHelper

  def list_edit_btn(current_announcement)
    
    if current_announcement.type == "PeditorAnnouncement"
      "#{link_to( '' , edit_admin_announcement_path(current_announcement), class: "edit")  }".html_safe
    elsif current_announcement.type == "CustomizedAnnouncement"
      "#{link_to( '', custom_edit_admin_announcement_path(current_announcement), class: "edit")  }".html_safe
    end
        
  end

  def list_edit_lnk(title, current_announcement)
    
    if current_announcement.type == "PeditorAnnouncement"
      "#{link_to( title , edit_admin_announcement_path(current_announcement))  }".html_safe
    elsif current_announcement.type == "CustomizedAnnouncement"
      "#{link_to( title , custom_edit_admin_announcement_path(current_announcement))  }".html_safe
    end
        
  end

  def is_set_top(is_top)
    if is_top < 999
      image_tag "/images/admin/up.png", title: "置頂"
    end
  end

end
