#encoding: utf-8
module OrderasksHelper
  def show_orderasks(orderasks)
    if(orderasks.length > 0)
      return render(partial: "show_orderasks", locals: { orderasks: orderasks })
    else
      return nil
    end
  end

  def get_orderask_status(orderask)
    if orderask.status == "new"
      link_to( "已處理", admin_orderask_path(orderask), :method => "put" , class: "uvs")
    else 
      "已處理"
    end
  end
end