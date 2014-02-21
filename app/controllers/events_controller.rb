class EventsController < ApplicationController
  respond_to :html, :js

  def index
    @new_event = Event.new
    @events_upcoming_week = Event.upcoming_week.all
    @events_upcoming = Event.upcoming.all
    @events_to_approve = Event.to_approve.all
  end

  def create
    p = params[:event]
    p[:date_start] = "#{params[:date_submit]} #{params[:time_start_submit]}"
    p[:date_end] = "#{params[:date_submit]} #{params[:time_end_submit]}"
    @new_event = Event.create(p)
    if @new_event.save
      respond_with @new_event
    else
      render :json => { :error => @new_event.errors.full_messages.to_sentence },
             :status => :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if editor_logged_in

      if params[:commit] == "Approve"
        @event = Event.find(params[:id])
        if @event.update_attribute(:approved, true)
          respond_with @event
        end
      elsif params[:commit] == "Approve & pick"
        @event = Event.find(params[:id])
        if @event.update_attributes(:approved => true, :editors_pick => true)
          respond_with @event
        end
      end

    end
  end

  def destroy
  end

end
