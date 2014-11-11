#encoding: utf-8
module ContactsHelper

  def get_contact_status(contact)
    if contact.status == "new"
      link_to( "已處理", admin_contact_path(contact), :method => "put" , class: "uvs")
    else 
      "已處理"
    end
  end

end