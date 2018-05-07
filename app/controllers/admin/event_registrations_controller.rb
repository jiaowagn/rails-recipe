require 'csv'

class Admin::EventRegistrationsController < AdminController
  before_action :find_event

  def index
    # ransack 会用数据库的 LIKE 语法来做搜寻，虽然用起来方便，但它会逐笔检查资料是否符合，而不会使用数据库的索引。
    # 如果数据量非常多有上万笔以上，搜寻效能就会不满足我们的需要。
    # 这时候会改安装专门的全文搜寻引擎，例如 Elasticsearch，这是大数据等级的。
    @q = @event.registrations.ransack(params[:q])
    @registrations = @q.result.includes(:ticket).order("id DESC").page(params[:page])
    if params[:registration_id].present?
      @registrations = @registrations.where(:id => params[:registration_id].split(","))
    end

    if params[:start_on].present?
      @registrations = @registrations.where("created_at >= ?", Date.parse(params[:start_on]).beginning_of_day )
    end

    if params[:end_on].present?
      @registrations = @registrations.where("created_at <= ?", Date.parse(params[:end_on]).end_of_day )
    end

    if Array(params[:statuses]).any?
      @registrations = @registrations.by_status(params[:statuses])
    end

    if Array(params[:ticket_ids]).any?
      @registrations = @registrations.by_ticket(params[:ticket_ids])
    end

    if params[:status].present?
      @registrations = @registrations.by_status(params[:status])
    end

    if params[:ticket_id].present?
      @registrations = @registrations.by_ticket(params[:ticket_id])
    end

    respond_to do |format|
      format.html
      format.csv {
        # CSV 是 Ruby 内建的库，这里第一行需要先 require 它。使用 CSV.generate 可以产生出 csv_string 字符串，
        # 也就是要输出的 CSV 资料，接着透过 send_data 传给浏览器进行档案下载
        @registrations = @registrations.reorder("id ASC")
        csv_string = CSV.generate do |csv|
          csv << ["报名ID", "票种", "姓名", "状态", "Email", "报名时间"]
          @registrations.each do |r|
            csv << [r.id, r.ticket.name, r.name, t(r.status, :scope => "registration.status"), r.email, r.created_at]
          end
        end
        send_data csv_string, :filename => "#{@event.friendly_id}-registrations-#{Time.now.to_s(:number)}.csv"
      }
    end
  end

  def destroy
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.destroy
    redirect_to admin_event_registrations_path(@event)
  end

  protected
    def registration_params
      params.require(:registration).permit(:ticket_id, :name, :email, :cellphone, :website, :bio)
    end

    def find_event
      @event = Event.find_by_friendly_id!(params[:event_id])
    end
end
