class StylebookEntriesController < ApplicationController
  def index
		@entries = StylebookEntry.all
  end

  def new
		@entry = StylebookEntry.new
  end

  def create
		@entry = StylebookEntry.new(params[:stylebook_entry])
		if @entry.save
			redirect_to stylebook_entries_path
		else
			render 'new'
		end
  end

  def edit
		@entry = StylebookEntry.find(params[:id])
  end

  def update
		@entry = StylebookEntry.find(params[:id])
		if @entry.update_attributes(params[:stylebook_entry])
			redirect_to stylebook_entries_path
		else 
			render 'edit'
		end
  end

  def destroy
		entry = StylebookEntry.find(params[:id])
		entry.destroy
		redirect_to stylebook_entries_path
  end

end
