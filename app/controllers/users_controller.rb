class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    def create
      @user = User.create(user_params)
      if @user.valid?
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
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
                @user.update(device_key:params[:deviceKey])
                render json: {user: @user}
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
  
    private
  
    def user_params
      params.permit(:username, :password, :device_key)
    end
  
  end