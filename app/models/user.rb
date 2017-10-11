class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_and_belongs_to_many :oauth_credentials
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # devise :omniauthable, omniauth_providers: [:google_oauth2]

   def admin?
   	role == "admin"
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.new_with_sessions(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true ) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
end
