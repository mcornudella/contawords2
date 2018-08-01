class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :executions, :inputparameters, :input_parameters
  end
end
