class Api::UsersController < ApplicationController

    def index
        @users = User.all
        render json: @users
    end 

    def show
        incoming_id = params[:id]
        @user = User.find_by(id: incoming_id)
        render json: ["no User found"] if !@user 
        render json: @user
    end 



    def create
        @user = User.new(user_params)
        if @user.save 
            login(@user)
            render json: @user
        else 
            render @user.errors.full_messages, status: 422
        end 
    end 

    def destroy 
        incoming_id = params[:id]
        @user = User.find_by(id: incoming_id)
        if @user.destroy 
            render json: @user
        else 
            render json: ["Cannot find user"]
        end 
        
    end 




    private 
    def user_params
        params.require(:user).permit(:username, :email, :first_name, :last_name, :bio, :password)
    end 
end
