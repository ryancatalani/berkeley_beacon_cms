class EventsController < ApplicationController
  respond_to :html, :js
  before_filter :check_editor

  def index
    @new_event = Event.new
    # @events_upcoming_week = Event.upcoming_week.all
    # @events_upcoming = Event.upcoming.all
    @events_all_upcoming = Event.all_upcoming.all.group_by{|e| e.date_start.to_s(:pretty_date_with_day)}
    @events_to_approve = Event.to_approve.all

    issue_event_articles = Article.where(:issue_id => Issue.latest.id, :section_id => Section.find_by_name("Events").id)
    picks_thursday = issue_event_articles.where(:event_day => 4).all
    picks_friday = issue_event_articles.where(:event_day => 5).all
    picks_saturday = issue_event_articles.where(:event_day => 6).all
    picks_ROW = issue_event_articles.where(:event_day => 10).all
    @beacon_picks = picks_thursday + picks_friday + picks_saturday + picks_ROW


    @other_sections = %w(News Opinion Arts Lifestyle Sports Feature Multimedia).map{|s| Section.find_by_name s}.compact
    @body_id = 'events_calendar'
    @body_class = 'a14'
    render 'index', :layout => 'bare'
  end

  def create
    p = params[:event]
    p[:date_start] = "#{params[:date_submit]} #{params[:time_start_submit]}"
    p[:date_end] = "#{params[:date_submit]} #{params[:time_end_submit]}"
    logger.debug "logged in?  #{editor_logged_in}"
    @new_event = Event.create(p, :editor_logged_in => editor_logged_in)
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
