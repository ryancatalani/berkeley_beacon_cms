class EventsController < ApplicationController
  respond_to :html, :js

  def index
    @new_event = Event.new
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
  end

  def destroy
  end

end
