# encoding: utf-8
module TemplateHelper

	def set_date date = nil
		@template_date = date.present? ? date.to_time : Time.now
	end

	def get_date
		@template_date
	end

	def render_date
		if @template_date.blank?
			@template_date = Time.now
		end
		Array.new([
			"y#{@template_date.strftime '%Y'}",
			"m#{@template_date.strftime '%m'}",
			"d#{@template_date.strftime '%d'}"
		])
	end

	alias_method :date, :set_date

	def set_title title = nil
		separator = '|'
		page_title = @template_title if @template_title.present?
		if title.present?
			page_title = "#{page_title} #{separator} #{title}"
		end
		page_title = clean_title "#{page_title} #{separator} #{I18n.t('app.name')}", separator
		@template_title = page_title.squish.html_safe
	end

	def get_title
		separator = @template_title_separator
		unless @template_title_separator.present?
			separator = '&mdash;'
		end
		@template_title.gsub('|', separator).squish.html_safe
	end

	def render_title
		content_for :title, get_title
	end

	alias_method :title, :set_title

	def set_schema schema = nil
		schema_endpoint_uri = 'http://schema.org'
		valid_root_schemas = [
			'SearchResultsPage',
			'CollectionPage',
			'ContactPage',
			'ProfilePage',
			'AboutPage',
			'ItemPage',
			'QAPage'
		]
		if schema.present? && valid_root_schemas.include?(schema)
			root_schema = schema
		elsif @template_schema.present? && valid_root_schemas.include?(@template_schema)
			root_schema = @template_schema
		else
			root_schema = 'WebPage'
		end
		@template_schema = "#{schema_endpoint_uri}/#{root_schema}"
	end

	def get_schema
		@template_schema
	end

	def render_schema
		content_for :schema, get_schema
	end

	alias_method :schema, :set_schema

	def set_classes *classes
		@template_classes = Array.new if @template_classes.blank?
		@template_classes += classes.to_a
		@template_classes.uniq!
	end

	def get_classes
		@template_classes.uniq!
		@template_classes.join(' ')
	end

	def render_classes
		@template_wrap_size ||= 'wrap-at-960px'
		set_classes @template_wrap_size,
			component,
			controller_name,
			action_name,
			render_date
		content_for :classes, get_classes
	end

	alias_method :classes, :set_classes

	def component_class_names block, element = nil, modifier = nil, options = {}
		classes = options[:omit_root].present? ? [] : [block]
		classes.push("#{block}__#{element}") if element.present?
		if modifier.present?
			if modifier.kind_of?(Array)
				modifier.reject!(&:blank?)
				modifier.each do |mod|
					classes.push("#{block}__#{element}--#{mod}")
				end
			else
				classes.push("#{block}__#{element}--#{modifier}")
			end
		end
		classes = classes.join(' ').gsub '__--', '--'
		classes.html_safe
	end

	def svg_tag filename, options = {}
		file = File.read Rails.root.join('public', 'assets', 'images', filename)
		doc = Nokogiri::HTML::DocumentFragment.parse file
		svg = doc.at_css 'svg'
		if options[:class].present?
			svg[:class] = options[:class]
		end
		doc.xpath('//comment()').remove
		doc.to_html.html_safe
	end

	def menu_item title, path, options = {}, html_options = {}
		current_class = current_page?(options) ? 'current' : ''
		if options[:action].blank?
			current_class = controller_name.to_s == options[:controller].to_s ? 'current' : ''
		end
		content_tag :li, class: current_class do
			link_to title, path, html_options
		end
	end

	protected

	def clean_title string, separator
		string.to_s.squish.chomp(separator).reverse.chomp(separator).reverse
	end

	def html_root
		output = "<!--[if lt IE 9 ]><html class=\"ie legacy\" lang=\"#{I18n.locale}\"> <![endif]-->\n" +
		"<!--[if IE 9 ]><html class=\"ie ie9\" lang=\"#{I18n.locale}\"> <![endif]-->\n" +
		"<!--[if IE 10 ]><html class=\"ie ie10\" lang=\"#{I18n.locale}\"> <![endif]-->\n" +
		"<!--[if (gte IE 10)|!(IE)]><!--><html lang=\"#{I18n.locale}\"> <!--<![endif]-->"
		output.html_safe
	end

	def breadcrumbs separator = '&rsaquo;'
		unless @breadcrumbs.blank?
			output = []
			position = 0
			@breadcrumbs[0..-2].each do |title, path|
				position = position + 1
				item = content_tag :span, { itemscope: true, itemprop: 'itemListElement', itemtype: 'http://schema.org/ListItem', class: 'breadcrumb' } do
					link_to(content_tag(:span, title, itemprop: 'name'), path, class: 'breadcrumb__item', itemprop: 'item') +
					content_tag(:meta, '', content: position, itemprop: 'position')
				end
				output << item
				output << content_tag(:span, separator.html_safe, class: 'breadcrumb__separator')
			end

			last_breadcrumb = @breadcrumbs.last
			last_item = content_tag(:span, { itemscope: true, itemprop: 'itemListElement', itemtype: 'http://schema.org/ListItem', class: 'breadcrumb' }) do
				link_to(content_tag(:span, last_breadcrumb.first, itemprop: 'name'), last_breadcrumb.last, class: 'breadcrumb__item breadcrumb__item--current', itemprop: 'item') +
				content_tag(:meta, '', content: position + 1, itemprop: 'position')
			end

			output << last_item
			content_tag(:p, output.join(' ').html_safe, itemscope: true, itemtype: 'http://schema.org/BreadcrumbList', class: 'breadcrumbs')
		end
	end

	def choose index, *args
		if index.is_a?(TrueClass) || index.is_a?(FalseClass)
			index = (index == true) ? 1 : 2
		end
		if index >= 0 && index <= args.count
			args[index - 1].to_s.html_safe
		end
	end

end
