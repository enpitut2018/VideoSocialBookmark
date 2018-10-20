require "uri"

class Entry < ApplicationRecord
  def self.create_or_get(title, url)
    if Entry.exists?(url:  url)
      return Entry.find_by(url: url)
    end
    return Entry.create(title: title,
                        url: url,
                        thumbnail_url: Entry.get_thumbnail(url))
  end

  def self.get_thumbnail(uri)
    parsed_uri = URI::parse(uri)
    if parsed_uri.host == "www.youtube.com"
      video_id = Hash[URI::decode_www_form(parsed_uri.query)]["v"]
      return "https://img.youtube.com/vi/" + video_id + "/default.jpg"
    end
  end
end
