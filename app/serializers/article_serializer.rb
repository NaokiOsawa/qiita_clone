class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :body, :title
  belongs_to :user
end
