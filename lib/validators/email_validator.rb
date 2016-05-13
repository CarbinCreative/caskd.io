# encoding: utf-8
class EmailValidator < ActiveModel::EachValidator

	REGEX_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	def validate_each record, attribute, value
		unless value.to_s =~ REGEX_EMAIL
			record.errors.add(attribute, options[:message] || 'is not valid')
		end
	end

end
