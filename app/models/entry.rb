require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "net/http"
require "json"
require "kconv"
require "youtube-dl"

class Entry < ApplicationRecord
  has_many :bookmarks
  has_many :users, through: :bookmarks
  has_many :comments, through: :bookmarks

  def self.create_or_get(url)
    if Entry.exists?(url: url)
      return Entry.find_by(url: url)
    end
    return Entry.create(title: Entry.get_title(url),
                        url: url,
                        thumbnail_url: Entry.get_thumbnail(url))
  end

  def self.get_thumbnail(uri)
    parsed_uri = URI::parse(uri)
    case parsed_uri.host
    when "www.youtube.com"
      video_id = Hash[URI::decode_www_form(parsed_uri.query)]["v"]
      return "https://img.youtube.com/vi/" + video_id + "/default.jpg"
    when "www.nicovideo.jp"
      id = parsed_uri.path.split("/")[-1][2..-1]
      return "http://tn-skr3.smilevideo.jp/smile?i=" + id + ".L"
    when "www.dailymotion.com"
      id = parsed_uri.path.split("/")[-1]
      return "https://www.dailymotion.com/thumbnail/video/" + id
    when "vimeo.com"
      id = parsed_uri.path.split("/")[-1]
      uri = "http://vimeo.com/api/v2/video/" + id + ".json"
      json = getJson(uri)
      return json[0]["thumbnail_large"]
    when "video.fc2.com"
      html = Nokogiri::HTML(open(uri))
      return html.css("#content_ad_head_wide > meta:nth-child(4)")[0].attributes["content"].value
    when "www.xvideos.com"
      html = Nokogiri::HTML(open(uri))
      return html.css("head > meta:nth-child(14)")[0].attributes["content"].value
    else
      options = {
        'dump-json': true,
      }
      video = YoutubeDL::Video.new uri, options
      information = video.information
      return information[:thumbnails][0][:url]
    end
  end

  def self.get_title(uri)
    parsed_uri = URI::parse(uri)
    title = uriToDoc(uri).title
    case parsed_uri.host
    when "www.youtube.com"
      title[0..-11]
    when "www.dailymotion.com"
      title[0..-13].split(" - ")[0..-2].join(" - ")
    when "video.fc2.com"
      if parsed_uri.path.split("/")[1] == "a"
        title[0..-15]
      else
        title[0..-9]
      end
    when "www.xvideos.com"
      title[0..-14]
    else
      title
    end
  end

  def self.update_num_of_bookmarked(entries)
    entries.each { |e| e.update_attributes(num_of_bookmarked: e.count_bookmarks) }
  end

  def count_bookmarks
    if bookmarks.loaded?
      bookmarks.to_a.count
    else
      bookmarks.count
    end
  end

  def self.latest_n_bookmarks(n)
    limit(n).preload(:bookmarks)
  end

  def self.comments
    bookmarks.map { |item|
      item.comments
    }.flatten
  end

  private

  def self.uriToDoc(uri)
    html = open(uri, "r:binary").read
    doc = Nokogiri::HTML(html.toutf8, nil, "utf-8")
  end

  def self.getJson(uri)
    uri = URI.parse(uri)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
  end
end
