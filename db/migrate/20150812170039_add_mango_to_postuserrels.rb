class AddMangoToPostuserrels < ActiveRecord::Migration
  def change
    add_column :postuserrels, :mango, :integer
  end
end
