class Api::SessionController < ApplicationController

    def create 
        username = params[:user][:username]
        password = params[:user][:password]
        user = User.find_by_credentials(username, password)
        if user 
            login(user)
        else 
            render json: ['Invalid Username or Password'], status: 404
        end 
    end 

    def destroy
        if current_user
          logout!
          render json: {}
        else
          render json: ['No one to logout'], status: 404
        end
      end
    
end
