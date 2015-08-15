class AddTypeToUserhashrels < ActiveRecord::Migration
  def change
    add_column :userhashrels, :type, :integer
  end
end
