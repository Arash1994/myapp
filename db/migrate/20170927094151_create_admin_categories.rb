class CreateAdminCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
