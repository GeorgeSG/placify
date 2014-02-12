module Placify
  class AuthController < Base
    NAMESPACE = '/auth'.freeze

    helpers UserHelpers

    get '/login' do
      erb :'auth/login'
    end

    post '/login' do
      username = params[:username]
      password = params[:password]

      puts username
      puts password

      if username.empty? || password.empty?
        redirect NAMESPACE + '/login', error: 'Please enter both username and password!'
      end

      user = User.where(username: username).first
      puts "#{user[:first_name]}"

      if user.nil?
        redirect NAMESPACE + '/login', error: 'There is no such user in our database!'
      end

      password = BCrypt::Engine.hash_secret(password, user.salt)
      if password != user.password
        redirect NAMESPACE + '/login', error: 'You\'ve entered an incorrect password!'
      end

      session[:uid] = user.id
      redirect '/', success: "Welcome, #{user.first_name}! Enjoy your stay!"
    end

    get '/logout' do
      session[:uid] = nil
      redirect '/', success: 'You\'ve logged out successfully! Have a nice day!'
    end

    get '/signup' do
      erb :'auth/signup'
    end

    post '/signup' do
      username         = params[:username]
      password         = params[:password]
      confirm_password = params[:confirm_password]
      first_name       = params[:first_name]
      last_name        = params[:last_name]



      if password != confirm_password
        flash[:error] = 'The two passwords do not match. Please try again!'
        redirect NAMESPACE + '/signup'
      end

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

      user = User.create(username: username,
                  password: password_hash,
                  salt: password_salt,
                  first_name: first_name,
                  last_name: last_name)

      unless user.valid?
        flash[:error] = user.errors.values.join("\n")
        redirect NAMESPACE + '/signup'
        #p user.errors.to_a.join(' ')
      end


      flash[:success] = 'You have registered succesfully!'
      redirect NAMESPACE + '/login'
    end
  end
end
