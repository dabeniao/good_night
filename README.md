# README

"good night" is an application that allows users to track when do they go to bed and when do they wake up.

## Environment

The project is developed with:

- Ruby version 3.1.2
- PostgreSQL as the database engine
- rspec as the test framework

## Authentication
Request authentication is achieved by providing a bearer token in the `X-Auth-Token` HTTP header field.

Calling `User#remember` in rails console generates a new token.

## APIs
- `POST` /sleep_sessions
create a sleep_session for the user
```ruby
# sample parameter format
{
    "sleep_session": {
        "slept_at": "2022-12-20T12:34:46Z",
        "woke_at": "2022-12-20T20:34:46Z"
    }
}
```
- `GET` /sleep_sessions
retrieve all the sleep_sessions of a user, ordered by `:created_at`
- `GET` /sleep_sessions/following
retrieve all the sleep_sessions of all the users followed by the user, ordered by sleep duration

- `PUT` /following_users/{id}
follow the user with the specified user id.
renders 404 if user cannot be found with the specified id

- `DELETE` /following_users/{id}
unfollow the user with the specified user id.
renders 404 if user cannot be found with the specified id

## Notes
- A PostgreSQL only function is used in `SleepSessionsController#following`.
- Request authentication helper methods are located in `app/helpers/user_sessions_helper.rb`
