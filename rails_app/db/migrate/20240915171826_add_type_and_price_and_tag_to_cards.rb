class AddTypeAndPriceAndTagToCards < ActiveRecord::Migration[7.1]
  def change
    # add_column :cards, :type, :string
    # add_column :cards, :price, :integer
    # add_column :cards, :tag, :string
    change_table :cards, bulk: true do |t|
      t.string :type
      t.string :tag
      t.integer :price
    end
  end
end
