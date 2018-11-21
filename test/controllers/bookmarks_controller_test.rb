# frozen_string_literal: true

require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
	  @user = User.create!(provider: "aaa", uid: "aaa", email: "hogehoge@example", encrypted_password: "hogehogehoge")
	  @entry = Entry.create!(title: "Mystring", url: "aaa", thumbnail_url: "aaa", video_id: 1, provider: "aaaa")
	  @bookmark = Bookmark.create!(user_id: 1, entry_id: 1, original_url: "Mystring")
  end

  test "should get index" do
    get api_v1_bookmarks_path, as: :json
    assert_response :success
  end

  test "should create bookmark" do
    assert_difference("Bookmark.count") do
      post api_v1_bookmarks_path, params: { bookmark: { comment: @bookmark.comment, original_url: @bookmark.original_url, private: @bookmark.private, star_count: @bookmark.star_count, thread_id: @bookmark.thread_id, user_id: @bookmark.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show bookmark" do
    get api_v1_bookmark_path(@bookmark), as: :json
    assert_response :success
  end

  test "should update bookmark" do
    patch api_v1_bookmark_path(@bookmark), params: { bookmark: { comment: @bookmark.comment, original_url: @bookmark.original_url, private: @bookmark.private, star_count: @bookmark.star_count, thread_id: @bookmark.thread_id, user_id: @bookmark.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy bookmark" do
    assert_difference("Bookmark.count", -1) do
      delete api_v1_bookmark_path(@bookmark), as: :json
    end

    assert_response 204
  end
end
