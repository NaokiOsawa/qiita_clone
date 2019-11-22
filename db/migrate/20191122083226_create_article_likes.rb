class CreateArticleLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :article_likes do |t|

      t.timestamps
    end
  end
end
