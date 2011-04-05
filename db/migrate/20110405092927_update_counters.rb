class UpdateCounters < ActiveRecord::Migration
  def self.up
    @counters = EntityCategoryCounter.all
    @counters.each do |i|
      i.update_attributes(:important_tag=>false)
    end

    @counters2 = CommentCategoryCounter.all
    @counters2.each do |i|
      i.update_attributes(:important_tag=>false)
    end
  end

  def self.down
  end
end
