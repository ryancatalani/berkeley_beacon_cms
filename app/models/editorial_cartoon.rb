class EditorialCartoon < ActiveRecord::Base

  has_one :mediafile
  belongs_to :issue


  def self.cartoons
  	self.order("issue_date DESC").map{ |ec| ec.mediafile }
  end

  def self.latest
  	self.order("issue_date DESC").first.mediafile
  end

end
