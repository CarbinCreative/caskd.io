# encoding: utf-8
class ApplicationController < ActionController::Base

	include BeforeRender
	include Breadcrumbable
	include ApplicationHelper

	protect_from_forgery with: :exception
	add_flash_types :success, :warning

	before_action :set_locale
	before_action :set_request_format

	before_render :set_template_properties, if: :responds_to_html?
	before_render :set_component_layout

	respond_to :html, :json

	def index
		set_classes 'landing'
	end

	protected

	def set_locale
		I18n.locale = :en
	end

	def responds_to_json?
		request.xhr? && request.format == :json
	end

	def responds_to_html?
		request.format == :html
	end

	def set_request_format
		if request.xhr?
			request.format = :json
		end
	end

	def set_template_properties
		set_date
		set_title
		set_schema
		set_classes
	end

	def set_component_layout
		@component = :frontend
	end

end
