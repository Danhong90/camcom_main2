class Post < ActiveRecord::Base
    has_many :posthashrels, dependent: :destroy  
    has_many :postuserrels, dependent: :destroy
    has_many :users, :through => :postuserrels
    has_many :campushashes, :through => :posthashrels
 
    default_scope {order('post_deadline ASC')}

end
