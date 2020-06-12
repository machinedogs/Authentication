# frozen_string_literal: true

class Host < ApplicationRecord # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable # Include default devise modules. Others available are:
  has_many :event, :dependent => :destroy
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
        
end
