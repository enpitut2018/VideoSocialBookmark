# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "TEST#{n}@example.com" }
    sequence(:password) { |n| "PASSWORD#{n}" }
    sequence(:password_confirmation) { |n| "PASSWORD#{n}" }
  end
end
