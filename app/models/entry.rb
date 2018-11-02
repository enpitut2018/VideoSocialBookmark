# frozen_string_literal: true

require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "net/http"
require "json"
require "kconv"
require "youtube-dl"

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

  def self.get_video_data(uri)
    parsed_uri = URI.parse(uri)
    case parsed_uri.host
    when "www.youtube.com"
      id = Hash[URI.decode_www_form(parsed_uri.query)]["v"]
      thumbnail = "https://img.youtube.com/vi/" + id + "/default.jpg"
      title = uriToDoc(uri).title[0..-11]
    when "www.nicovideo.jp"
      id = parsed_uri.path.split("/")[-1][2..-1]
      thumbnail = "http://tn-skr3.smilevideo.jp/smile?i=" + id + ".L"
      title = uriToDoc(uri).title
    when "www.dailymotion.com"
      id = parsed_uri.path.split("/")[-1]
      thumbnail = "https://www.dailymotion.com/thumbnail/video/" + id
      title = uriToDoc(uri).title[0..-13].split(" - ")[0..-2].join(" - ")
    else
      options = {
        'dump-json': true
      }
      video = YoutubeDL::Video.new uri, options
      information = video.information
      thumbnail = information[:thumbnails][0][:url]
      title = information[:title]
    end

    [title, thumbnail]
  end

  def self.comments
    bookmarks.map(&:comments).flatten
  end

  def self.uriToDoc(uri)
    parsed_uri = URI.parse(uri)
    charset = nil
    html = parsed_uri.open do |f|
      charset = f.charset
      f.read
    end
    Nokogiri::HTML.parse(html, nil, charset)
  end

  def self.getJson(uri)
    uri = URI.parse(uri)
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end

  private

  def fetchVideoData
    self.title, self.thumbnail_url = Entry.get_video_data(url)
  end
end
