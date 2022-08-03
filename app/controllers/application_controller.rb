class ApplicationController < ActionController::Base

    def current_user
        !!@current
    end
end
