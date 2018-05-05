class AddRowOrderToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :row_order, :integer
    Event.find_each do |e|
      #数据库已经有的 events 默认是 nil, 这里要设定 row_order 的值，其中 `:last` 是 ranked-model
      e.update(:row_order => :last)
    end
    add_index :events, :row_order
  end
end
