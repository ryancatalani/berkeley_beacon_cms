class ArticleEventBinder < ActiveRecord::Base
  attr_accessible :article_id, :event_id
  belongs_to :event
  belongs_to :article
end
