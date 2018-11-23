# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  serialization_scope :view_context

  def genPagination(obj, includes, total, page, per_page)
    obj.includes(includes)
    obj_json = ActiveModel::SerializableResource.new(obj, include: includes, scope: view_context)
    {
      data: obj_json,
      total: total,
      page: page,
      per_page: per_page,
      page_count: (total.to_f / per_page.to_f).ceil
    }
  end
end
