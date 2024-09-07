class AddAttributesToCard < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :name, :string
    add_column :cards, :title, :string
    add_column :cards, :year, :integer
  end
end
