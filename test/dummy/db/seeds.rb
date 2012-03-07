p 'Creating : ' + User.create!(:email => 'admin@example.com', :password => 'test123', :password_confirmation => 'test123').email.to_s
