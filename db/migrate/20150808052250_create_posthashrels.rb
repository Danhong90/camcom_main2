class CreatePosthashrels < ActiveRecord::Migration
  def change
    create_table :posthashrels do |t|
        t.belongs_to :campushash, index: true
        t.belongs_to :post, index: true
        
      t.timestamps null: false
    end
  end
end
