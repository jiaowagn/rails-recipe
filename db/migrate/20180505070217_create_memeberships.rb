class CreateMemeberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memeberships do |t|
      t.integer :group_id, :index => true
      t.integer :user_id, :index => true
      t.timestamps
    end
  end
end
