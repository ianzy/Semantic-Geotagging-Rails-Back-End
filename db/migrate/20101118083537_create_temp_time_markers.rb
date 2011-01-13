class CreateTempTimeMarkers < ActiveRecord::Migration
  def self.up
    create_table :temp_time_markers do |t|
      
      t.timestamps
    end
  end

  def self.down
    drop_table :temp_time_markers
  end
end
