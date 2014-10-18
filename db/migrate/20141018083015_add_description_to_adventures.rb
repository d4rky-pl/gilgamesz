class AddDescriptionToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :name, :string
    add_column :adventures, :description, :text
    add_column :adventures, :game_type, :integer
  end
end
