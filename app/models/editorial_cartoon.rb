class EditorialCartoon < ActiveRecord::Base
  attr_accessible :issue_id, :slug
  has_one :mediafile
  belongs_to :issue


  def self.cartoons
  	self.all.map{ |ec| ec.mediafile }
  end

end
