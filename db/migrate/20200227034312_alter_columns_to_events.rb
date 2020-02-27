class AlterColumnsToEvents < ActiveRecord::Migration[6.0]
  def up    
    change_table :events do |t|
      
      t.rename :start_time, :start
      t.rename :end_time, :end
      t.string :state
      t.integer :isAllDay
      
    end
  end

  def down
    change_table :events do |t|      
      t.rename :start, :start_time
      t.rename :end, :end_time 
      t.remove :state
      t.remove :isAllDay
    end
  end
end
