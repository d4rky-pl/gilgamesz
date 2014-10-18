class AddPlaysToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :plays, :integer, default: 0
  end
end
