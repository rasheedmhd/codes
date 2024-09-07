class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :poster
      t.string :company

      t.timestamps
    end
  end
end
