class CreateMusics < ActiveRecord::Migration[7.1]
  def change
    create_table :musics do |t|
      t.string :artist
      t.string :title
      t.string :tag
      t.string :label
      t.string :country
      t.string :genre
      t.string :release_date

      t.timestamps
    end
  end
end
