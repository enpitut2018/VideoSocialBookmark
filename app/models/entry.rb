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

  before_save :fetchVideoDataIfNot

  validates :video_id, uniqueness: { scope: [:provider] }

  def self.find_or_initialize_by_original_url(original_url)
    find_or_initialize_by(url: original_url_to_url(original_url))
  end

  def self.find_entry_by_original_url(original_url)
    url = original_url_to_url(original_url)

    entry = Entry.find_by(url: url)
    return entry unless entry.nil?

    is_http = url.length > 5 && url[0..4] == "http:"
    if is_http
      protocol_exchanged_url = url.gsub(/^http:/, "https:")
      entry = Entry.find_by(url: protocol_exchanged_url)
      return entry unless entry.nil?
    end

    is_https = url.length > 6 && url[0..5] == "https:"
    if is_https
      protocol_exchanged_url = url.gsub(/^https:/, "http:")
      entry = Entry.find_by(url: protocol_exchanged_url)
      return entry unless entry.nil?
    end

    nil
  end

  def self.original_url_to_url(original_url)
    #  TODO : パラメータなどをカットする処理を実装する
    original_url
  end

  def self.get_video_data(uri)
    sites = {
      youtube: /[m|www]\.youtube\.com/,
      nicovideo: /[sp|www]\.nicovideo\.jp/,
      dailymotion: /www\.dailymotion\.com/
    }
    parsed_uri = URI.parse(uri)
    title = fetchTitleFromUrl(uri) if sites.key?(parsed_uri.host)
    case parsed_uri.host
    when sites[:youtube]
      provider = "youtube"
      id = Hash[URI.decode_www_form(parsed_uri.query)]["v"]
      thumbnail = "https://img.youtube.com/vi/" + id + "/maxresdefault.jpg"
      title = fetchTitleFromUrl(uri)[0..-11]
    when sites[:nicovideo]
      provider = "nicovideo"
      id = parsed_uri.path.split("/")[-1]
      thumbnail = "http://tn.smilevideo.jp/smile?i=" + id[2..-1] + ".L"
      title = fetchTitleFromUrl(uri)[0..-9]
    when sites[:dailymotion]
      provider = "dailymotion"
      id = parsed_uri.path.split("/")[-1]
      thumbnail = "https://www.dailymotion.com/thumbnail/video/" + id
      title = fetchTitleFromUrl(uri)[0..-13].split(" - ")[0..-2].join(" - ")
    else
      begin
        options = {
          'dump-json': true
        }
        video = YoutubeDL::Video.new uri, options
        information = video.information
        thumbnail = information[:thumbnails][0][:url]
        title = information[:title]
        id = information[:id]
        provider = information[:extractor]
      rescue Terrapin::ExitStatusError => _
        thumbnail = ""
        title = fetchTitleFromUrl(uri)
        id = ""
        provider = "unknown"
      end
    end

    [id, title, thumbnail, provider]
  end

  def self.comments
    bookmarks.map(&:comments).flatten
  end

  def self.fetchTitleFromUrl(url)
    url = URI(url)
    return "No title" unless url.respond_to?(:open)

    # rubocop:disable Security/Open (open is replaced by open-uri)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    # rubocop:enable Security/Open

    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.title
  end

  private

  def fetchVideoDataIfNot
    self.video_id, self.title, self.thumbnail_url, self.provider = Entry.get_video_data(url) unless title
  end
end
