# Parliament Authentication API

This API is responsible for authenticating users and interacting with the user database.

## Configuration

* Ruby version = 2.7.1
* Authentication: Devise & JWT
* Database = Postgresql

## Deployment Instructions
### Development Environment
- Run ``` bundle install ``` in root directory
- Start server with ``` rails s ```
     - Default command runs server on ```localhost:3000```

## Endpoints:
- ```/users ```
    - Create a new User
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
          "id": 2837729,
          "username": "abc@example.com",
          "password_digest": "$2a$12$rwK30VcjoM9L6iendeyM9.wAktjfU8MlUbBI2O11BH.QK.vNukCwW",
          "device_key": "testKey",
          "created_at": "2020-10-13T19:00:27.836Z",
          "updated_at": "2020-10-14T01:25:23.774Z"
      },
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhwSp7ZzrgcaxSxTw6tedbiw-zuAUbubg"
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
          "id": 2837729,
          "username": "abc@example.com",
          "password_digest": "$2a$12$rwK30VcjoM9L6iendeyM9.wAktjfU8MlUbBI2O11BH.QK.vNukCwW",
          "device_key": "testKey",
          "created_at": "2020-10-13T19:00:27.836Z",
          "updated_at": "2020-10-14T01:25:23.774Z"
      },
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhwSp7ZzrgcaxSxTw6tedbiw-zuAUbubg"
    }
- ```/device_key ```
    - Update a users push notification device key
    - Example Payload: 
    ```
      { 
        "token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.68NcogyO1TlhZSp7ZzrgcaxSxTw6tedbiw-zuAUbubg", 
        "deviceKey":"testKey"
      }
    ```
    - Example Successful Return:
    ```
    {
      "status": "Device Key Succesfully Posted",
      "user": {
          "id": 2,
          "device_key": "testKey",
          "password_digest": "$2a$12$rfD20VcjoM9X6ienOeyM9.wAdsjfU8MlUPBI2O11BH.QK.vNukCwW",
          "username": "abc@ex3ample.com",
          "created_at": "2020-10-13T19:00:27.836Z",
          "updated_at": "2020-10-14T01:25:23.774Z"
    }

    

