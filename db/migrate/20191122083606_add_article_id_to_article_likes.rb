class AddArticleIdToArticleLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :article_likes, :article, foreign_key: true
  end
end
