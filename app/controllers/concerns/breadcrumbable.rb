# encoding: utf-8
module Breadcrumbable

	extend ActiveSupport::Concern

	included do

		protected

		def breadcrumb title, path = nil
			@breadcrumbs ||= []
			@breadcrumbs << [title, path || nil]
		end

		def self.breadcrumb title, path, options = {}
			before_action options do |controller|
				controller.send(:breadcrumb, title, path)
			end
		end

	end

end
