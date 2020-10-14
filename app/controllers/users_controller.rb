class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    def create
      existing_user = User.find_by(username: params[:username])
      # Check if user already exists, if they do return error
      if existing_user
        render json: {error: "User already exists"}
      else # username is not taken
        # Make new user
        @user = User.create(user_params)
        if @user.valid?
          token = encode_token({user_id: @user.id})
          render json: {user: @user, token: token}
        else
          render json: {error: "Invalid username or password"}
        end
      end
      
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])
  
      if @user && @user.authenticate(params[:password])
        # make new token and salt it so its different
        token = JWT.encode({user_id: @user.id, salt: token_salt}, 's3cr3t')
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end

    # Update Device Key
    def device_key
        decoded_token = JWT.decode(params[:token], 's3cr3t', true, algorithm: 'HS256')
        # Check if token was decoded
        if decoded_token
            @user = User.find_by(id: decoded_token[0]['user_id'])
            if @user # user exists
                # update the device_key for the user
                @user.update(device_key: params[:deviceKey])
                render json: {status: "Device Key Succesfully Posted"}
            else
                render json: {error: "Invalid User"}
            end
        else # token is null
            render json: {error: "Invalid Token"}
        end
    end

    # DELETE
    def delete
      decoded_token = JWT.decode(params[:token], 's3cr3t', true, algorithm: 'HS256')
        # Check if token was decoded
        if decoded_token
            @user = User.find_by(id: decoded_token[0]['user_id'])
            if @user # user exists
                # update the device_key for the user
                User.find_by(id: @user.id).delete
                render json: {status: "User was succesfully deleted"}
            else
                render json: {error: "Invalid User"}
            end
        else # token is null
            render json: {error: "Invalid Token"}
        end
    end
  
  
    def auto_login
      render json: @user
    end
    
    def token_salt
      ('0'..'z').to_a.shuffle.first(8).join
    end
  
    private
  
    def user_params
      params.permit(:username, :password, :device_key)
    end
  
  end