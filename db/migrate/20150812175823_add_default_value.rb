class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column_default(:postuserrels, :mango, 0)
    change_column_default(:postuserrels, :melon, 0)
  end
end
