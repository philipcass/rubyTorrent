class User
	def authenticate(username,password)
		if username == "philip" && password == "dongs" 
			success!("LOHIN YE")
			puts "succeeded"
		else
			fail!("Could not log in")
			puts "fail"
		end
	end



end