module EventsHelper
  def display_status(event)
    case event.status
    when "draft"
      "草稿"
    when "public"
      "公开"
    when "private"
      "私密"
    end     
  end
end
