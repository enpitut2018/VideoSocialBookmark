class Entry < ApplicationRecord
  def self.create_or_get(title, url)
      Entry.exists?(url:  url) ? Entry.find_by(url: url) : Entry.create(title: title, url: url)
  end
end
