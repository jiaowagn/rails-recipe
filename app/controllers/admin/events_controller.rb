class Admin::EventsController < AdminController

  def index
    @events = Event.rank(:row_order).all
  end

  def show
    @event = Event.find_by_friendly_id!(params[:id])
    colors =['rgba(255, 99, 132, 0.2)',
             'rgba(54, 162, 235, 0.2)',
             'rgba(255, 206, 86, 0.2)',
             'rgba(75, 192, 192, 0.2)',
             'rgba(153, 102, 255, 0.2)',
             'rgba(255, 159, 64, 0.2)'
           ]
    ticket_names = @event.tickets.map{|t| t.name}
    @data1 = {
      labels: ticket_names,   #横轴的标签有哪些
      datasets: [{
        label: "# of Registrations",  # 数据集的名称
        data: @event.tickets.map{|t| t.registrations.count}, # 数据（这是数组）
        backgroundColor: colors,  #长条的颜色
        borderWidth: 1  #要有框线
      }]
    }
  end

  def new
    @event = Event.new
    @event.tickets.build
    @event.attachments.build
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to admin_events_path
    else
      render "new"
    end
  end

  def edit
    @event = Event.find_by_friendly_id!(params[:id])
    @event.tickets.build if @event.tickets.empty?
    @event.attachments.build if @event.attachments.empty?
  end

  def update
    @event = Event.find_by_friendly_id!(params[:id])

    if @event.update(event_params)
      redirect_to admin_events_path
    else
      render "edit"
    end
  end

  def destroy
    @event = Event.find_by_friendly_id!(params[:id])
    @event.destroy

    redirect_to admin_events_path
  end

  def bulk_update
    total = 0
    # 关于 Array(params[:ids] 这个用法，如果是 Array([1,2,3]) 会等同于 [1,2,3] 没变，
    # 但是 Array[nil] 会变成 [] 空数组，这可以让 .each 方法不会因为 nil.each 而爆错。
    # 如果不这样处理，在没有勾选任何活动就送出的情况，就会爆出 NoMethodError 错误。
    # 除非你额外检查 params[:id] 如果是 nil 就返回，但不如用 Array 来的精巧。
    Array(params[:ids]).each do |event_id|
      event = Event.find(event_id)
      if params[:commit] == I18n.t(:bulk_update)
        event.status = params[:event_status]
        event.save
        total += 1
      end

      if params[:commit] == I18n.t(:bulk_delete)
        event.destroy
        total += 1
      end
    end
    flash[:alert] = "成功完成 #{total} 笔"
    redirect_to admin_events_path
  end

  def reorder
    @event = Event.find_by_friendly_id!(params[:id])
    @event.row_order_position = params[:position]
    @event.save!
    respond_to do |format|
      format.html {redirect_to admin_events_path}
      format.json {render :json => {:message => "ok"}}
    end
  end

  protected

  def event_params
    # :images => [] 要放在最后，因为默认的 Hash 哈希参数都是放在参数最后
    params.require(:event).permit(:name, :logo, :remove_logo, :remove_images, :description, :friendly_id, :status, :category_id, :images => [],
                                  :tickets_attributes => [:id, :name, :description, :price, :_destroy],
                                  :attachments_attributes => [:id, :attachment, :description, :_destroy])
  end

end
