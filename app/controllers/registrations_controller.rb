class RegistrationsController < ApplicationController
  before_action :find_event
  before_action :authenticate_user!, expect: [:show]

  def new
  end

  def create
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user
    # 这里针对 ticket 额外用 @event.tickets.find 再检查确定这个票种属于这个活动
    @registration.ticket = @event.tickets.find(params[:registration][:ticket_id])
    @registration.status = "confirmed"
    if @registration.save
      redirect_to event_registration_path(@event, @registration)
    else
      render 'new'
    end
  end

  def show
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  protected
    def find_event
      @event = Event.find_by_friendly_id(params[:event_id])
    end

    def registration_params
      params.require(:registration).permit(:ticket_id, :name, :email, :cellphone, :webiste, :bio)
    end
end
