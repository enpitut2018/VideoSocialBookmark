# frozen_string_literal: true

require "uri"
require "json"
require "open-uri"
require "nokogiri"

class Entry < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :entry_stars, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :comments, through: :bookmarks

  def self.create_or_get(url)
    return Entry.find_by(url: url) if Entry.exists?(url: url)

    Entry.create(title: Entry.get_title(url),
                 url: url,
                 thumbnail_url: Entry.get_thumbnail(url))
  end

  def self.get_thumbnail(uri)
    parsed_uri = URI.parse(uri)
    if parsed_uri.host == "www.youtube.com"
      video_id = Hash[URI.decode_www_form(parsed_uri.query)]["v"]
      return "https://img.youtube.com/vi/" + video_id + "/default.jpg"
    end
  end

  def self.get_title(uri)
    parsed_uri = URI.parse(uri)
    if parsed_uri.host == "www.youtube.com"
      charset = nil
      html = parsed_uri.open do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      return doc.title
    end
  end

  def self.update_num_of_bookmarked(entries)
    entries.each { |e| e.update(num_of_bookmarked: e.bookmarks.size) }
  end

  private

  def self.latest_n_bookmarks(n)
    limit(n).preload(:bookmarks)
  end

  def self.comments
    bookmarks.map(&:comments).flatten
  end
end
