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
          new_access_token = create_access_token(@user.id)
          render json: {user: @user, token: {accessToken: new_access_token.jwt, expiration: new_access_token.expiration }}
        else
          render json: {error: "Invalid username or password"}
        end
      end
      
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])
      # Make sure user exists and password is correct
      if @user && @user.authenticate(params[:password])
        # Delete previous accessToken now that the user is logging in
        old_access_token = Blacklist.find_by(jwt:params[:token])
        # Check if the user has a previous one first
        if old_access_token
          Blacklist.find_by(jwt:params[:token]).delete
        end
        # now that old accessToken is invalidated make a new one ans 
        new_access_token = create_access_token(@user.id)
        render json: {user: @user, token: {accessToken: new_access_token.jwt, expiration: new_access_token.expiration }}
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
                # Make usre accessToken is valid
                access_token_record = Blacklist.find_by(jwt: params[:token])
                if access_token_record && Time.now < access_token_record.expiration 
                  # update the device_key for the user
                  @user.update(device_key: params[:deviceKey])
                  render json: {status: "Device Key Succesfully Posted"}
                else
                  render json: {status: "Token Expired"}
                end
                
            else
                render json: {error: "Invalid User"}
            end
        else # token is null
            render json: {error: "Invalid Token"}
        end
    end

    # LOGOUT
    def logout
      decoded_token = JWT.decode(params[:token], 's3cr3t', true, algorithm: 'HS256')
        # Check if token was decoded
        if decoded_token
            @user = User.find_by(id: decoded_token[0]['user_id'])
            if @user # user exists
                # Invalidate their access token
                # Next time they try to access resources with their access token they will be denied
                Blacklist.find_by(jwt: params[:token]).delete
                render json: {status: "User was succesfully logged out"}
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
                Blacklist.find_by(jwt: params[:token]).delete
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

    # Creates a new Blacklist token with expiration to Blacklist table and returns it
    def create_access_token(user_id)
      # Create new access token
      token = JWT.encode({user_id: user_id, salt: token_salt()}, 's3cr3t')
      exp_time = Time.now + 15*60
      Blacklist.create({ jwt: token, expiration: exp_time })
    end
  
    private
  
    def user_params
      params.permit(:username, :password, :device_key)
    end
  
  end