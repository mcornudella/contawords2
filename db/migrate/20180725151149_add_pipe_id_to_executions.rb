class AddPipeIdToExecutions < ActiveRecord::Migration[5.2]
  def change
    add_column :executions, :pipe_id, :integer
  end
end
