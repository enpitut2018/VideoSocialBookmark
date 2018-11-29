# frozen_string_literal: true

module RequestSpecHelper
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end

  def login
    post "/api/v1/auth/sign_in", params: { format: "json", email: "TEST1@example.com", password: "PASSWORD1" }
    @headers = response.headers
    @headers = @headers.map { |k, v| [k, v] }.to_h
    @headers.delete("Content-Type")
  end

  def snapshot(title, url, params = nil, black_list = [])
    api_v1_url = "/api/v1" + url
    if params
      post api_v1_url, params: { format: "json", **params }, headers: @headers
    else
      get api_v1_url
    end
    data = JSON.parse(response.body)
    black_list.each do |key|
      data.delete(key.to_s)
    end
    expect(JSON.pretty_generate(data)).to match_snapshot(api_v1_url + "---" + title)
  end
end
