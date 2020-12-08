# Parliament Authentication API

This API is responsible for authenticating users and interacting with the user database.

## Configuration

* Ruby version = 2.7.1
* Authentication: Devise & JWT
* Database = Postgresql

# Deployment Instructions
## Production Environment
### Host
http://a87713a1fd4b64cd4b788e8a1592de07-1206905140.us-west-2.elb.amazonaws.com

### Development Environment
- Run ``` bundle install ``` in root directory
- Start server with ``` rails s ```
     - Default command runs server on ```localhost:3000```
### Host
http://localhost:3000

## Endpoints:
- ```/users ```
    - Create a new User
    - Example Payload: 
    ```
    { 
      "username":"example@example.com", 
      "password":"password" 
    }
    ```
    - Example Successful Return:
    ```
    {
         "user": {
             "id": 3,
             "username": "example@example.com",
             "password_digest": "$2a$12$08p1thhSwbRpyJiiQi./uu.fUl2L7OPEpz9JwscvL4ueH0LJqCazO",
             "device_key": null,
             "created_at": "2020-10-15T06:09:07.237Z",
             "updated_at": "2020-10-15T06:09:07.237Z"
         },
         "auth": {
             "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoiYWNjZXNzIiwic2FsdCI6IlxcVG9qPWFOZCJ9.LhrFlPQjmhOMZRks2oP4jIC9O5gKltBwsYs-Vy39Bic",
             "accessTokenExpiration": "2020-10-15T06:24:07.245Z",
             "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoicmVmcmVzaCIsInNhbHQiOiJma191MEk4SCJ9.haRij-MTblMtZIa9quxorRsiz_oT10yiMkp8w4aoKEI",
             "refreshTokenExpiration": "2020-11-14T06:09:07.253Z"
         }
     }
- ```/login ```
    - Login an existing user
    - Example Payload: 
    ```
    { 
      "username":"exampleUser", 
      "password":"examplePassword" 
    }
    ```
    - Example Successful Return:
    ```
    {
         "user": {
             "id": 3,
             "username": "example@example.com",
             "password_digest": "$2a$12$08p1thhSwbRpyJiiQi./uu.fUl2L7OPEpz9JwscvL4ueH0LJqCazO",
             "device_key": null,
             "created_at": "2020-10-15T06:09:07.237Z",
             "updated_at": "2020-10-15T06:09:07.237Z"
         },
         "auth": {
             "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoiYWNjZXNzIiwic2FsdCI6IlxcVG9qPWFOZCJ9.LhrFlPQjmhOMZRks2oP4jIC9O5gKltBwsYs-Vy39Bic",
             "accessTokenExpiration": "2020-10-15T06:24:07.245Z",
             "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoicmVmcmVzaCIsInNhbHQiOiJma191MEk4SCJ9.haRij-MTblMtZIa9quxorRsiz_oT10yiMkp8w4aoKEI",
             "refreshTokenExpiration": "2020-11-14T06:09:07.253Z"
         }
     }
- ```/refresh ```
    - Refreshes a users refresh and access tokens
    - Example Payload: 
    ```
      { 
        "refreshToken":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg"
      }
    ```
    - Example Successful Return:
    ```
    {
         "status": "Refreshed Tokens",
         "auth": {
             "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoiYWNjZXNzIiwic2FsdCI6IlxcVG9qPWFOZCJ9.LhrFlPQjmhOMZRks2oP4jIC9O5gKltBwsYs-Vy39Bic",
             "accessTokenExpiration": "2020-10-15T06:24:07.245Z",
             "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJ0eXBlIjoicmVmcmVzaCIsInNhbHQiOiJma191MEk4SCJ9.haRij-MTblMtZIa9quxorRsiz_oT10yiMkp8w4aoKEI",
             "refreshTokenExpiration": "2020-11-14T06:09:07.253Z"
         }
     }
- ```/logout ```
    - Logout a user
    - Example Payload: 
    ```
      { 
        "accessToken":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg"
      }
    ```
    - Example Successful Return:
    ```
    {
      "status": "User was succesfully logged out"
    }
- ```/delete ```
    - Delete a user
    - Example Payload: 
    ```
      { 
        "accessToken":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg",
        "refreshToken":"rt4hbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.58NcogyO1TlhZSp7dzrgcaxwxTw6tedbww-zuAUbrbg"
      }
    ```
    - Example Successful Return:
    ```
    {
      "status": "User was succesfully deleted"
    }
- ```/device_key ```
    - Update a users push notification device key
    - Example Payload: 
    ```
      { 
        "accessToken":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg", 
        "deviceKey":"testKey"
      }
    ```
    - Example Successful Return:
    ```
    {
      "status": "Device Key Succesfully Posted"
    }
- ```/device_keys ```
    - Returns an array of all User device tokens
    - Example Payload: 
    ```
      { 
        "accessToken":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg"
      }
    ```
    - Example Successful Return:
    ```
    {
         "device_keys": [
             "730400683bbf7ab482ab8c5e36c671fd1a151a58f170cd028a243b189ff61ad7",
           "fSAwLeogRrmjwHpUd6siQE:APA91bGi7leNgGinbwgu0tE3DZrelOCpxEW1woxWODTz9ldR9WKyAAXz0AmLrbjjYxH6oyaDgmJ9JiTicWo12mekYyXoDbY3ZR08cpXlyVzzEgQQAxCMSu0Ttny81Ki-ovf70zE0Qrcp"
         ]
    }

    

    

