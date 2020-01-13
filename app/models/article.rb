class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  enum status: { draft: 0, published: 1 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
