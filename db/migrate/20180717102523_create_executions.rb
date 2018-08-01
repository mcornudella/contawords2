class CreateExecutions < ActiveRecord::Migration[5.2]
  def change
    create_table :executions do |t|
      t.integer :status
      t.text :inputparameters
      t.references :user, foreign_key: true
      t.string :execution_id

      t.timestamps
    end
  end
end
