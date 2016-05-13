# encoding: utf-8
module ComponentHelper

	@component = instance_variable_get(:@component)
	@component_layout = instance_variable_get(:@component_layout)
	@component_stylesheet = instance_variable_get(:@component_stylesheet)

	def component
		if @component.present?
			@component
		else
			if controller_path.index('/').present?
				controller_path.split('/').first.downcase
			else
				'frontend'
			end
		end
	end

	def component_layout
		if @component_layout.present?
			@component_layout.downcase
		else
			component
		end
	end

	def component_title
		component_title_identifier = "component.#{component.downcase}"
		I18n.t component_title_identifier.to_sym, default: component.to_s.capitalize
	end

	def component_stylesheet
		stylesheet = @component_stylesheet || component
		asset_include_path = Rails.root.join 'public', 'assets', 'stylesheets'
		stylesheet_include_path = "#{asset_include_path}/#{stylesheet.to_s}.css"
		if File.exists?(stylesheet_include_path)
			stylesheet_link_tag "/assets/stylesheets/#{stylesheet.to_s}", media: 'all'
		end
	end

	def component_javascript controller = nil
		controller ||= params[:controller]
		asset_include_path = Rails.root.join 'public', 'assets', 'javascripts'
		javascript_include_path = "#{asset_include_path}/#{controller}.js"
		if File.exists?(javascript_include_path)
			javascript_include_tag "/assets/javascripts/#{controller}"
		end
	end

end
