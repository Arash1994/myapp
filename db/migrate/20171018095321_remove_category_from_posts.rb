class RemoveCategoryFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :posts, :category, foreign_key: true
  end
end
