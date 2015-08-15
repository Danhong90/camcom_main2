class AddMelonToPostuserrels < ActiveRecord::Migration
  def change
    add_column :postuserrels, :melon, :integer
  end
end
