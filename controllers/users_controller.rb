module Placify
  class UsersController < Base
    NAMESPACE = '/users'.freeze

    helpers UserHelpers

    get '/' do
      @title = 'Users'
      @users = User.all

      erb :'users/index'
    end

    get '/preferences', auth: :logged do
      erb 'welcome, friend'
    end

    get '/:id' do
      @user = User.where(id: params[:id]).first
      redirect '/', error: 'There is no such user' if @user.nil?

      @title = "#{ @user.first_name } #{ @user.last_name }"
      erb :'users/view'
    end
  end
end
