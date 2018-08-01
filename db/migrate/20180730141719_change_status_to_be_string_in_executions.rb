class ChangeStatusToBeStringInExecutions < ActiveRecord::Migration[5.2]
  def change
    change_column :executions, :status, :string
  end
end
