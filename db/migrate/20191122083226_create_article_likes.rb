class CreateArticleLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :article_likes, &:timestamps
  end
end
