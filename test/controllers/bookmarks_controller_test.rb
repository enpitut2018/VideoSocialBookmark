# frozen_string_literal: true

require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
	  @bookmark = Bookmar.create!(user_id: 1, entry_id: 1)
  end

  test "should get index" do
    get bookmarks_url, as: :json
    assert_response :success
  end

  test "should create bookmark" do
    assert_difference("Bookmark.count") do
      post bookmarks_url, params: { bookmark: { comment: @bookmark.comment, original_url: @bookmark.original_url, private: @bookmark.private, star_count: @bookmark.star_count, thread_id: @bookmark.thread_id, user_id: @bookmark.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show bookmark" do
    get bookmark_url(@bookmark), as: :json
    assert_response :success
  end

  test "should update bookmark" do
    patch bookmark_url(@bookmark), params: { bookmark: { comment: @bookmark.comment, original_url: @bookmark.original_url, private: @bookmark.private, star_count: @bookmark.star_count, thread_id: @bookmark.thread_id, user_id: @bookmark.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy bookmark" do
    assert_difference("Bookmark.count", -1) do
      delete bookmark_url(@bookmark), as: :json
    end

    assert_response 204
  end
end
