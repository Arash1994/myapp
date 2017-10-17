class AddFieldToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :country_code, :string
    add_column :users, :authy_id, :string
    add_column :users, :verified, :boolean, :default => false
  end
end
