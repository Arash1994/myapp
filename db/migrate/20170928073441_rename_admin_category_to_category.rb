class RenameAdminCategoryToCategory < ActiveRecord::Migration[5.1]
  def change
  	rename_table :admin_categories, :categories
  end
end
