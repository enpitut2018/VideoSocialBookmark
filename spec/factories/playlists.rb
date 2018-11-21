# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    user_id { 1 }
    name { "MyString" }
    is_private { false }
  end
end
