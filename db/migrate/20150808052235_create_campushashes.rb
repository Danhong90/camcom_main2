class CreateCampushashes < ActiveRecord::Migration
  def change
    create_table :campushashes do |t|
        t.string :hash_content
        t.string :hash_category
      t.timestamps null: false
    end
  end
end
