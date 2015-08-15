class Userhashrel < ActiveRecord::Base
    belongs_to :user
    belongs_to :campushash
end
