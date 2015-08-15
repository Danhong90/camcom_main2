class Posthashrel < ActiveRecord::Base
    belongs_to :post
    belongs_to :campushash
end
