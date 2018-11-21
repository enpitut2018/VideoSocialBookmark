# frozen_string_literal: true

require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
	  @entry = Entry.create!(title: "Mystring", url: "aaa", thumbnail_url: "aaa", video_id: 1, provider: "aaaa")
  end

  test "should create entry" do
    assert_difference 'Entry.count', 1 do
      post api_v1_entries_path, params: { entry: {title: "Mystring", 
						  url: "aaa", 
						  thumbnail_url: "aaa", 
						  video_id: 1, 
						  provider: "aaaa"} }, as: :json
    end
    assert_response 201
  end

  test "should show entry" do
    get api_v1_entry_path(@entry), as: :json
    assert_response :success
  end
end

