$("#result").html("<%= escape_javascript render(@users) %>")
$("#user_pager").html("<%= escape_javascript(paginate @users ,:window => 2 , :remote => true).to_s %>")