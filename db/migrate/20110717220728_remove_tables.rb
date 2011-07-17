class RemoveTables < ActiveRecord::Migration
  def self.up
    drop_table :resps
    drop_table :temp_time_markers
  end

  def self.down
  end
end
