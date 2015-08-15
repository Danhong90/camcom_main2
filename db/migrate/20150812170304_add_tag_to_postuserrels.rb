class AddTagToPostuserrels < ActiveRecord::Migration
  def change
    add_column :postuserrels, :tag, :integer
  end
end
