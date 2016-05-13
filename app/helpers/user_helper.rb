# encoding: utf-8
require 'digest'

module UserHelper

	def gravatar_url email, size = 80
		hash = Digest::MD5.hexdigest(email.downcase)
		"https://secure.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
	end

	def avatar_url user, size = :small
		avatar_url = gravatar_url user.email
		if user.avatar.present?
			avatar_url = user.avatar.url(size)
		end
		avatar_url
	end

	def avatar user, options = {}
		size = options[:size] || 'thumb'
		user_avatar_url = avatar_url user, size
		class_names = component_class_names('avatar', 'image', size)
		capture_haml do
			haml_tag :span, class: component_class_names('avatar', 'image', size), style: "background-image:url('#{user_avatar_url}');"
		end
	end

	def avatar_link user, link, options = {}
		size = options[:size] || 'thumb'
		user_avatar_url = avatar_url user, size
		class_names = component_class_names('avatar', 'link', size)
		capture_haml do
			haml_tag :a, href: link, class: "#{class_names} #{options[:class]}".squish do
				haml_tag :span, class: component_class_names('avatar', 'image', size), style: "background-image:url('#{user_avatar_url}');"
			end
		end
	end

end
