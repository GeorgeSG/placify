module Placify
  module UserHelpers
    def logged?
      not session[:uid].nil?
    end
  end
end
