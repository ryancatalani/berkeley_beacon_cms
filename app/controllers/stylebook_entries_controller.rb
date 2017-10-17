class StylebookEntriesController < ApplicationController
  def index
		@entries = StylebookEntry.all
  end

  def new
		@entry = StylebookEntry.new
  end

  def create
		@entry = StylebookEntry.new(stylebook_entry_params)
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
		if @entry.update_attributes(stylebook_entry_params)
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

  private

  def stylebook_entry_params
  	params.require(:stylebook_entry).permit(:body, :notes)
  end

end
