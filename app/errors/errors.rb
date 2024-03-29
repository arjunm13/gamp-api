# here is the module defines all handleable erros
module Errors

	# here defines the general error class
	class GampError < Exception

		# constructor
		def initialize(code, message)
			@code = code
			@error = message
		end

		def status
			@code
		end

		def error
			@error
		end

		def to_hash
			{
				code: status,
				error: error 
			}
		end

		# convert error to json 
		def to_json(*)
			to_hash.to_json
		end

	end

	class BadRequestError < GampError
		def initialize(message)
			@code = 400
			@error = message
		end
	end

	# unauthorized error
	class UnauthorizedRrror < GampError
		def initialize
			@code = 401
			@error = 'valid credential required to proform this action.'
		end
	end

	# mongodid error
	class UnprocessableEntityError < GampError
		def initialize(fields)
			@code = 422
			@error = 'the request contains unprocessable entities.'
			@fields = fields
		end

		def fields
			@fields
		end

		def to_hash
			{
				code: status,
				error: error,
				fields: @fields.to_hash
			}
		end
	end

	# routing error
	class RoutingError < GampError
		def initialize(path)
			@code = 404
			@error = 'the resource requested: \'' + path + '\' could not be found.'
		end
	end

	# internal server msssage.
	# devmessage should not be shown to users
	class InternalError < GampError
		def initialize(message)
			@code = 500
			@error = 'oops! something went wrong on server.'
			@devmessage = message
		end

		def to_hash
			hash = self.class.superclass.instance_method(:to_hash).bind(self).call
			hash[:devmessage] = @devmessage
			hash
		end
	end

end