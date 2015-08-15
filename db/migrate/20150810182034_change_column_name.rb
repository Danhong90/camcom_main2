class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :userhashrels, :type, :pick_type
  end
end
