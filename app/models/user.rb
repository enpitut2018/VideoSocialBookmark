# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bookmarks, :dependent => :destroy
  has_many :entry_stars, :dependent => :destroy
  has_many :entries, through: :bookmarks
  has_many :comments, through: :bookmarks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
