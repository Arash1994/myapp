class CreateIntrests < ActiveRecord::Migration[5.1]
  def change
    create_table :intrests do |t|
      t.belongs_to :user, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
