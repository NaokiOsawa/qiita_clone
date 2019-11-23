class AddUserIdToArticleLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :article_likes, :user, foreign_key: true
  end
end
