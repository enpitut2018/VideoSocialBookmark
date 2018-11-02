# frozen_string_literal: true

require "uri"
require "json"
require "open-uri"
require "nokogiri"

class Entry < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :entry_stars, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :bookmarks

  before_save :fetchVideoData

  def self.find_or_initialize_by_original_url(original_url)
    find_or_initialize_by(url: original_url_to_url(original_url))
  end

  def self.original_url_to_url(original_url)
    #  TODO : パラメータなどをカットする処理を実装する
    original_url
  end

  def self.get_thumbnail(uri)
    parsed_uri = URI.parse(uri)
    return unless parsed_uri.host == "www.youtube.com"

    video_id = Hash[URI.decode_www_form(parsed_uri.query)]["v"]
    "https://img.youtube.com/vi/" + video_id + "/default.jpg"
  end

  def self.get_title(uri)
    parsed_uri = URI.parse(uri)
    return unless parsed_uri.host == "www.youtube.com"

    charset = nil
    html = parsed_uri.open do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.title
  end

  def self.comments
    bookmarks.map(&:comments).flatten
  end

  private

  def fetchVideoData
    self.title = Entry.get_title(url)
    self.thumbnail_url = Entry.get_thumbnail(url)
  end
end
