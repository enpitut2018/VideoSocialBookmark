# frozen_string_literal: true

require "rails_helper"
require "devise"

RSpec.describe "Api::V1::Integrations", type: :request do
  before do
    @user = create(:user)
    login
  end

  describe "GET /" do
    it "check all snapshot" do
      snapshot("1. 開く", "/trend")
      snapshot("1. 開く", "/trend/preload")
      snapshot("2. エントリを投稿", "/entries", "entry": { "original_url": "https://www.youtube.com/watch?v=C5WJXffAT4A" }, "comment": { "content": "test" })
      snapshot("2. トレンドの更新", "/trend")
      snapshot("3. スターをつける", "/stars/entries/1", {}, %i[created_at updated_at])
      snapshot("3. コメントもつける", "/entries/1/comments", "comment": { "content": "いいね" })
      snapshot("3. コメントあるか", "/entries/1/comments")
      snapshot("3. 更新されてるか", "/entries/1")
      snapshot("4. ユーザーページ", "/users/1/bookmarks")
    end
  end
end
