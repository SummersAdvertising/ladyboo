$("#cart_amount_options").empty()
  .append("<%= escape_javascript(render 'products/fetch_amount_result', stock: @stock, amount_in_cart: @amount_in_cart) %>")