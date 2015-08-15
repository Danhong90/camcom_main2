class Campushash < ActiveRecord::Base
    has_many :posthashrels, dependent: :destroy
    has_many :userhashrels, dependent: :destroy
    
    has_many :posts, :through => :posthashrels
    has_many :users, :through => :userhashrels
 
    
end
