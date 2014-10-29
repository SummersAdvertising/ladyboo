$ ->
  #fetch_stock_amount
  $(document).on 'change', '#cart_stock', (evt) ->
    $.ajax '/products/fetch_stock_amount',
      type: 'GET'
      dataType: 'script'
      data: {
        stock_id: $("#cart_stock option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        #console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        #console.log("Ajax stock select OK!")
  
  #qv_fetch_stock_amount
  $(document).on 'change', '#qv_cart_stock', (evt) ->
    $.ajax '/products/fetch_stock_amount',
      type: 'GET'
      dataType: 'script'
      data: {
        stock_id: $("#qv_cart_stock option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        #console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        #console.log("Ajax stock select OK!")