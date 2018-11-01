# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :comments
  has_many :entry_stars
  has_many :bookmarks
  has_many :entries, through: :bookmarks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
