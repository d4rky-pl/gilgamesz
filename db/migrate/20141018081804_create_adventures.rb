class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.json :content
      t.string :token

      t.timestamps
    end
  end
end
