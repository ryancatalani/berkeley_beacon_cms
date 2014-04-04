class EventsController < ApplicationController
  respond_to :html, :js
  before_filter :check_editor, :except => [:index, :create]

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
    @include_responsive = true
    render 'index', :layout => 'bare'
  end

  def create
    p = params[:event]

    days = params[:date].select{|e| e.is_a? String}
    times_start = params[:time_start].select{|e| e.is_a? String}
    times_end = params[:time_end].select{|e| e.is_a? String}

    dates = []
    days.each_with_index do |day, index|
      date = {}
      date[:start] = Time.parse("#{day} #{times_start[index]} #{Time.zone.name}")
      date[:end] = times_end[index].blank? ? nil : Time.parse("#{day} #{times_end[index]} #{Time.zone.name}")
      dates << date
    end

    p[:date_start] = dates.first[:start]
    p[:date_end] = dates.first[:end]

    if editor_logged_in
      p[:approved] = true
    end

    @new_event = Event.create(p)
    if @new_event.save
      dates.shift
      dates.each do |date|
        e = params[:event]
        e[:date_start] = date[:start]
        e[:date_end] = date[:end]
        e[:approved] = true if editor_logged_in
        e[:parent_id] = @new_event.id
        Event.create!(e)
      end

      respond_with @new_event
    else
      render :json => { :error => @new_event.errors.full_messages.to_sentence },
             :status => :unprocessable_entity
    end
  end

  def show
    redirect_to root_path if !editor_logged_in
    @url = Event.find_by_uid(params[:uid]).url(true)
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
