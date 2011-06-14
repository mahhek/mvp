class UserSession < Authlogic::Session::Base

  validate :generic_error

	def generic_error
    RAILS_DEFAULT_LOGGER.debug "checking errors ..."
		clear = false
		errors.each do |attr,message|
      puts "================================================================="
			puts "Error: #{attr.inspect}: #{message}"
			if ( (attr == 'email' and message == 'is not valid') or 
            (attr == 'email' and message == 'cannot be blank') or
            (attr == 'email' and message == 'does not exist') or
            (attr == 'password' and message == 'cannot be blank') or
            (attr == 'password' and message == 'is not valid') )
				clear = true
			end
		end

		if clear
			RAILS_DEFAULT_LOGGER.debug "clearing errors ..."
			errors.clear
			errors.add_to_base("Oops! please check your email address or password.")
		end
	end


end
