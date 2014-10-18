class AddLikesToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :likes, :integer, default: 0
  end
end
