# encoding: utf-8
module Tokenizable

	extend ActiveSupport::Concern

	included do
		before_create :generate_token
	end

	protected

	def generate_token
		if has_attribute? :token
			self.token = loop do
				random_token = SecureRandom.hex(4)
				break random_token unless self.class.exists? token: random_token
			end
		end
	end

end
