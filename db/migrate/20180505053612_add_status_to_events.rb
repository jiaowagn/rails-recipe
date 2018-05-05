class AddStatusToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :status, :string, :defautl => 'draft'
  end
end
