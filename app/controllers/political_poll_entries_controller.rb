class PoliticalPollEntriesController < ApplicationController
  respond_to :html, :js

  def index
  end

  def new
    @title = "2012 Emerson College Political Poll"
  	@entry = PoliticalPollEntry.new
  	@include_bootstrap = true
  	@genders = @entry.poll_options(:genders)
  	@classes = @entry.poll_options(:classes)
  	@locations = @entry.poll_options(:locations)
    @yesno = @entry.poll_options(:yesno)
    @vote_prob = @entry.poll_options(:vote_prob)
    @parties = @entry.poll_options(:parties)
    @obama_romney = @entry.poll_options(:obama_romney)
    @certainty = @entry.poll_options(:certainty)
    @attention = @entry.poll_options(:attention)
    @frequency = @entry.poll_options(:frequency)
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
