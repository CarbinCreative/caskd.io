# encoding: utf-8
class Api::ApplicationController < ApplicationController

  RESOURCES_PER_PAGE = 25
  RESOURCE_META = {
    resourceCount: 1,
    resourceLimit: Api::ApplicationController::RESOURCES_PER_PAGE,
    pageCurrent: nil,
    pageCount: nil
  }

  include ApplicationHelper
  include ActionView::Helpers::UrlHelper

  layout false

  before_action :set_locale
  before_action :set_view_path
  before_action :set_request_format

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def index
    resolve api_root_path
  end

  protected

  def default_serializer_options
    { root: "results" }
  end

  def resource_meta(resource, additional_meta = {})
    Api::ApplicationController::RESOURCE_META.merge(additional_meta)
  end

  def resources_meta(resources, additional_meta = {})
    Api::ApplicationController::RESOURCE_META.merge({
      resourceCount: resources.total_entries,
      resourceLimit: Api::ApplicationController::RESOURCES_PER_PAGE,
      pageCurrent: resources.current_page,
      pageCount: resources.total_pages,
    }).merge(additional_meta)
  end

  def set_locale
    I18n.locale = :en
  end

  def set_view_path
    prepend_view_path "app/views/api/#{controller_name}"
  end

  def set_request_format
    request.format = :json
  end

end
