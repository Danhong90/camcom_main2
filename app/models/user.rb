class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  
  has_many :postuserrels, dependent: :destroy
  has_many :userhashrels, dependent: :destroy
  has_many :posts, :through => :postuserrels
  has_many :campushashes, :through => :postuserrels
  
  def self.from_omniauth(auth)
    check_presence = where(email: auth.info.email).take
    if where(email: auth.info.email).take.nil?
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
    else
      update(check_presence.id, :provider => auth.provider, :uid => auth.uid)
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
end
