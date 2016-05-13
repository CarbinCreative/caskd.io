# encoding: utf-8
class SlugValidator < ActiveModel::EachValidator

	REGEX_SLUG = /\A[-_.A-Za-z]*\z/

	def validate_each record, attribute, value
		unless value.to_s =~ REGEX_SLUG
			record.errors.add(attribute, options[:message] || 'is not valid')
		end
	end

end
