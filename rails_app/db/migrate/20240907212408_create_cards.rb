class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|

      t.timestamps
    end
  end
end
