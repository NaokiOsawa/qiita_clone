class UserSerializer < ActiveModel::Serializer
  attributes :id, :account, :name

  has_many :articles, dependent: :destroy
end
