class CreateUserhashrels < ActiveRecord::Migration
  def change
    create_table :userhashrels do |t|
        t.belongs_to :user, index: true
        t.belongs_to :campushash, index: true
        
      t.timestamps null: false
    end
  end
end
