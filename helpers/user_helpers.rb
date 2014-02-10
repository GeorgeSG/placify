module Placify
  module UserHelpers
    def logged?
      not session[:uid].nil?
    end

    def logged_user
      return nil unless logged?

      User.where(id: session[:uid]).first
    end
  end
end
