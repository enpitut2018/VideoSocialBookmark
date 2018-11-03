# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def index
    render file: "public/index.html", layout: false, content_type: "text/html"
  end
end
