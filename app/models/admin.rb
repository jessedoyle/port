class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable,
  # :remeberable and :confirmable,
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
end
