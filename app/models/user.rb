class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[github vkontakte]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end
end
