# encoding: utf-8
module ControllerHelper

	FLASH_KEYS = [
		'success',
		'notice',
		'warning',
		'alert',
		'error'
	]

  def resolve *args
		options = args.extract_options!
		location = args.first
		response = ActiveSupport::HashWithIndifferentAccess.new(
			status: :ok,
			location: location
		).merge!(options)
		unless response[:errors].blank?
			response[:status] = :error
		end
		ControllerHelper::FLASH_KEYS.each do |flash_key|
			flash_type = flash_key.to_sym
			unless response[flash_type].blank?
				response[:message] = response[flash_type]
				flash[flash_type] = response[:message]
				unless [:notice, :warning, :alert, :success].include? flash_type
					response[:status] = :error
				end
			end
		end
		@response = OpenStruct.new response
		if options[:render].present?
			render options[:render]
			return
		end
		respond_with response
	end

end
