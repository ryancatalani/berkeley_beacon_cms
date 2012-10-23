class PoliticalPollEntriesController < ApplicationController
  respond_to :html, :js

  def index
  end

  def new
    @title = "2012 Emerson College Political Poll"
    @og = {}
    @og[:description] = "Fill out the 2012 Emerson College political poll, and see how your peers are voting! The poll closes on Oct. 30."
  	@entry = PoliticalPollEntry.new
  	@include_bootstrap = true
  	@genders = @entry.poll_options(:genders)
  	@classes = @entry.poll_options(:classes)
  	@locations = @entry.poll_options(:locations)
    @locations_na = @entry.poll_options(:locations_na)
    @yesno = @entry.poll_options(:yesno)
    @yesno_na = @entry.poll_options(:yesno_na)
    @vote_prob = @entry.poll_options(:vote_prob)
    @parties = @entry.poll_options(:parties)
    @obama_romney = @entry.poll_options(:obama_romney)
    @obama_romney_other = @entry.poll_options(:obama_romney_other)
    @certainty = @entry.poll_options(:certainty)
    @attention = @entry.poll_options(:attention)
    @frequency = @entry.poll_options(:frequency)
    @issues = @entry.poll_options(:issues)
    render 'new', :layout => 'bare'
  end

  def create
    p = params[:political_poll_entry]
    p[:ip_digest] = Digest::SHA1.hexdigest(request.remote_ip).to_s
    p[:end_time] = Time.now.to_i
    p[:already_completed] = !cookies[:ppc].nil?
    @entry = PoliticalPollEntry.new(p)
    if @entry.save
      cookies.permanent.signed[:ppc] = true # i.e. political poll completed
      logger.debug "saved"
      respond_with "true"
    end
  end


end
