# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Entry.create([{
#     title: 'star wars',
#     url: 'hogehoge.com',
#     thumbnail_url: 'fugagufa.com',
#     num_of_bookmarked: 1
# }])
# Entry.create([{
#     title: 'sword art online',
#     url: 'hogehoge.com',
#     thumbnail_url: 'fugagufa.com',
#     num_of_bookmarked: 2
# }])
# Entry.create([{
#     title: 'accel world',
#     url: 'hogehoge.com',thumbnail_url: 'fugagufa.com',num_of_bookmarked: 4}])
# Entry.create([{
#     title: 'aaaaaa',
#     url: 'hogehoge.com',
#     thumbnail_url: 'fugagufa.com',
#     num_of_bookmarked: 5
# }])
# Entry.create([{
#     title: '147015',
#     url: 'hogehoge.com',
#     thumbnail_url: 'fugagufa.com',
#     num_of_bookmarked: 8
# }])

# Playlist.create(
#   [
#     {
#       id: 1,
#       user_id: 1,
#       name: "like",
#       is_private: false
#     }
#   ]
# )
# PlaylistItem.create(
#   [
#     {
#       id: 1,
#       playlist_id: 1,
#       entry_id: 1,
#       prev_id: 0,
#       next_id: 2
#     },
#     {
#       id: 2,
#       playlist_id: 1,
#       entry_id: 1,
#       prev_id: 1,
#       next_id: 0
#     }
#   ]
# )
require "json"
require "benchmark"

def createPlaylist(data, cnt)
  detail = data["playlist"]
  entries = data["entries"]

  # Create User
  user = User.find_or_create_by(name: detail["user_name"]) do |user|
    user.name = detail["user_name"]
    user.password = "newgame"
    user.email = cnt.to_s + "@example.com"
  end

  # Create Playlist
  playlist = Playlist.create(
    user_id: user.id,
    name: detail["name"][6..-8],
    is_private: false,
    created_at: detail["created"],
    updated_at: detail["updated"]
  )

  # Create Entries
  entries_length = entries.length
  db = {
    entries: [],
    bookmarks: [],
    comments: [],
    playlistItems: []
  }
  entry_ids = []
  entries.each_with_index do |entry, _cnt|
    entry_db = Entry.find_or_initialize_by(url: entry["url"]) do |entry_db|
      entry_db.title =
        if entry["title"].rindex("by").nil?
          entry["title"]
        else
          entry["title"][0..(entry["title"].rindex("by") - 1)]
        end
      entry_db.url = entry["url"]
      entry_db.created_at = entry["created"]
      entry_db.thumbnail_url = entry["thumbnail"]
      entry_db.video_id = entry["id"]
      entry_db.provider = "nicovideo"
    end
    if entry_db.new_record?
      db[:entries] << entry_db
      entry_ids.push(nil)
    else
      entry_ids.push(entry_db.id)
    end
  end
  new_entry_list = Entry.import db[:entries]
  new_entry_ids = new_entry_list.ids
  ids_cnt = 0
  entry_ids.each_with_index do |id, i|
    if id.nil?
      entry_ids[i] = new_entry_ids[ids_cnt]
      ids_cnt += 1
    end
  end
  entries.each_with_index do |entry, cnt|
    entry_id = entry_ids[cnt]
    db[:bookmarks] << Bookmark.new(
      user_id: user.id,
      entry_id: entry_id,
      star_count: 0,
      private: false,
      original_url: entry["url"],
      created_at: entry["created"]
    )
    if entry["comment"].present?
      db[:comments] << Comment.new(
        user_id: user.id,
        entry_id: entry_id,
        content: entry["comment"],
        created_at: entry["created"]
      )
    end
    db[:playlistItems] << PlaylistItem.new(
      playlist_id: playlist.id,
      entry_id: entry_id,
      prev_id: cnt != 0 ? cnt : -1,
      next_id: cnt != (entries_length - 1) ? cnt + 2 : -1,
      created_at: entry["created"]
    )
  end

  Bookmark.import db[:bookmarks]
  Comment.import db[:comments]
  PlaylistItem.import db[:playlistItems]
end

def loadDB
  cnt = 0
  Dir.glob("data/playlist/*").sort { |a, b| a <=> b }.each do |file|
    cnt += 1

    print cnt, " : ", file, "\n"
    File.open(file) do |fh|
      json = JSON.load(fh)
      createPlaylist(json, cnt)
    end
  end

  p "Set num_of_bookmarked"
  ActiveRecord::Base.connection.execute('update entries set "num_of_bookmarked" =
            (select count(*) from bookmarks where bookmarks.entry_id = entries.id);')

  p "Update user emails"
  ActiveRecord::Base.connection.execute("update users set email = (id || '@video-social-bookmark.com');")
end

# loadDB()
