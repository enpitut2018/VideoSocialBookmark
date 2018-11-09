FactoryBot.define do
  factory :playlist_item do
    playlist_id { 1 }
    entry_id { 1 }
    prev_id { 1 }
    next_id { 1 }
  end
end
