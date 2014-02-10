module Placify
  class MainController < Base
    NAMESPACE = '/'

    helpers UserHelpers

    get '/' do
      erb :'home/index'
    end

    get '/about' do
      erb :'home/about'
    end

    get '/login' do
      erb :'home/login'
    end

    post '/login' do
      username = params[:username]
      password = params[:password]

      if username.empty? || password.empty?
        redirect '/login', error: 'Please enter both username and password!'
      end

      user = User.where(username: username).first

      if user.nil?
        redirect '/login', error: 'There is no such user in our database!'
      end

      password = BCrypt::Engine.hash_secret(password, user.salt)
      if password != user.password
        redirect '/login', error: 'You\'ve entered an incorrect password!'
      end

      session[:uid] = user.id
      redirect '/', success: "Welcome, #{user.first_name}! Enjoy your stay!"
    end

    get '/logout' do
      session[:uid] = nil
      redirect '/', success: 'You\'ve logged out successfully! Have a nice day!'
    end

    get '/signup' do
      erb :'home/signup'
    end

    post '/signup' do
      username         = params[:username]
      password         = params[:password]
      confirm_password = params[:confirm_password]
      first_name       = params[:first_name]
      last_name        = params[:last_name]
      email            = params[:email]

      if password != confirm_password
        flash[:error] = 'The two passwords do not match. Please try again!'
        redirect '/signup'
      end

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

      User.create(username: username,
                  password: password_hash,
                  salt: password_salt,
                  first_name: first_name,
                  last_name: last_name,
                  email: email)

      flash[:success] = 'You have registered succesfully!'
      redirect '/login'
    end
  end
end
