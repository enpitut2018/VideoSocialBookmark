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
Playlist.create(
  [
    {
      id: 1,
      user_id: 1,
      name: "like",
      is_private: false
    }
  ]
)
PlaylistItem.create(
  [
    {
      id: 1,
      playlist_id: 1,
      entry_id: 1,
      prev_id: 0,
      next_id: 2
    },
    {
      id: 2,
      playlist_id: 1,
      entry_id: 1,
      prev_id: 1,
      next_id: 0
    }
  ]
)
