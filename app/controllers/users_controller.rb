class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    # IN - username, password
    # OUT - user, accessToken, refreshToken
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
          new_refresh_token = create_refresh_token(@user.id)
          render json: {user: @user, auth: {accessToken: new_access_token.jwt, accessTokenExpiration: new_access_token.expiration, refreshToken: new_refresh_token.jwt, refreshTokenExpiration: new_refresh_token.expiration  }}
        else
          render json: {error: "Invalid username or password"}
        end
      end
      
    end
  
    # LOGGING IN
    # IN - username, password
    # OUT - user, accessToken, refreshToken
    def login
      @user = User.find_by(username: params[:username])
      # Make sure user exists and password is correct
      if @user && @user.authenticate(params[:password])
        new_access_token = create_access_token(@user.id)
        new_refresh_token = create_refresh_token(@user.id)
        render json: {user: @user, auth: {accessToken: new_access_token.jwt, accessTokenExpiration: new_access_token.expiration, refreshToken: new_refresh_token.jwt, refreshTokenExpiration: new_refresh_token.expiration  }}
      else # User didn't exist or password was incorrect
        render json: {error: "Invalid username or password"}
      end
    end

    # REFRESH
    # IN - refreshToken
    # OUT - status, accessToken, refreshToken
    def refresh 
      decoded_refresh_token = JWT.decode(params[:refreshToken], 's3cr3t', true, algorithm: 'HS256')
      # Check if token was decoded
      if decoded_refresh_token
          @user = User.find_by(id: decoded_refresh_token[0]['user_id'])
          if @user # user exists
              Blacklist.find_by(jwt: params[:refreshToken]).delete
              # update the device_key for the user
              new_access_token = create_access_token(@user.id)
              new_refresh_token = create_refresh_token(@user.id)
              render json: {status: "Refreshed Tokens", auth: {accessToken: new_access_token.jwt, accessTokenExpiration: new_access_token.expiration, refreshToken: new_refresh_token.jwt, refreshTokenExpiration: new_refresh_token.expiration  }}
          else
              render json: {error: "Invalid User"}
          end
      else # token is null
          render json: {error: "Invalid Token"}
      end
    end

    # Update Device Key
    # IN - deviceKey, accessToken
    # OUT - status
    def device_key
        decoded_access_token = JWT.decode(params[:accessToken], 's3cr3t', true, algorithm: 'HS256')

        if decoded_access_token # Check if token was decoded
            @user = User.find_by(id: decoded_access_token[0]['user_id'])
            if @user # user exists
                # Make usre accessToken is valid
                access_token_record = Blacklist.find_by(jwt: params[:accessToken])
                if access_token_record && Time.now < access_token_record.expiration 
                  # update the device_key for the user
                  @user.update(device_key: params[:deviceKey])
                  render json: {status: "Device Key Succesfully Posted"}
                else
                  render json: {status: "Token Expired"}
                end
            else # User does not exist
                render json: {error: "Invalid User"}
            end
        else # token is null
            render json: {error: "Invalid Token"}
        end
    end

    # LOGOUT
    # IN - accessToken
    # OUT - status
    def logout
      decoded_access_token = JWT.decode(params[:accessToken], 's3cr3t', true, algorithm: 'HS256')
        # Check if token was decoded
        if decoded_access_token
            @user = User.find_by(id: decoded_access_token[0]['user_id'])
            if @user # user exists
                # Invalidate their access token
                # Next time they try to access resources with their access token they will be denied
                Blacklist.find_by(jwt: params[:accessToken]).delete
                render json: {status: "User was succesfully logged out"}
            else
                render json: {error: "Invalid User"}
            end
        else # token is null
            render json: {error: "Invalid Token"}
        end
    end

    # DELETE
    # IN - accessToken, refreshToken
    # OUT - status
    def delete
      decoded_access_token = JWT.decode(params[:accessToken], 's3cr3t', true, algorithm: 'HS256')
      decoded_refresh_token = JWT.decode(params[:refreshToken], 's3cr3t', true, algorithm: 'HS256')
      # Check if token was decoded
      if decoded_access_token && decoded_refresh_token
          @user = User.find_by(id: decoded_access_token[0]['user_id'])
          if @user # user exists
              Blacklist.find_by(jwt: params[:accessToken]).delete
              Blacklist.find_by(jwt: params[:refreshToken]).delete
              User.find_by(id: @user.id).delete
              render json: {status: "User was succesfully deleted"}
          else
              render json: {error: "Invalid User"}
          end
      else # token is null
          render json: {error: "Invalid Tokens"}
      end
    end
  
  
    def auto_login
      render json: @user
    end
    
    def token_salt
      ('0'..'z').to_a.shuffle.first(8).join
    end

    # Creates JWT that expires in 15 mintues and contains user id, token type, and a salt
    def create_access_token(user_id)
      # Create new access token
      token = JWT.encode({user_id: user_id, type: "access", salt: token_salt()}, 's3cr3t')
      exp_time = Time.now + 15*60 # 15 minutes
      Blacklist.create({ jwt: token, expiration: exp_time })
    end

    # Creates JWT that expires in 30 days and contains user id, token type, and a salt
    def create_refresh_token(user_id)
      # Create new access token
      token = JWT.encode({user_id: user_id, type: "refresh", salt: token_salt()}, 's3cr3t')
      exp_time = Time.now + 30*24*60*60 # 30 days
      Blacklist.create({ jwt: token, expiration: exp_time })
    end
  
    private
  
    def user_params
      params.permit(:username, :password, :device_key)
    end
  
  end