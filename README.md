# FITBOD API Code

API for manage workouts from users using Ruby on Rails 6 and PostgreSql.

### Requirements

You can run this project using docker-compose. The guide below will be for using docker-compose.

### Installation

Follow the steps below
```sh
git clone git@github.com:zaffalon/fitbod.git
```
Open the folder
```sh
cd fitbod
```
Build the project in docker
```sh
docker-compose build
```
Create the tables in PostgreSql
```sh
docker-compose run api rake db:create
```
Migrate the tables
```sh
docker-compose run api rake db:migrate
```
Run the server in docker
```sh
docker-compose up
```

### Running Tests

Use the following commands to run the automated tests.

```sh
docker-compose run api rspec
```

### API Endpoint

#### Running Localy
http://localhost:3000/

#### Running in Heroku
https://fitbod-zaffalon.herokuapp.com/

1. You need to create a User `POST /users`
2. You can create a session for this user `POST /sessions`
3. Using the token provided you can magane your own workouts `POST/GET/PATCH/DELETE /workouts`

For more informations about the API and params use the documentation below.

### API Endpoint Documentation (Swagger)

#### Running Localy
Visit: http://localhost:3000/api-docs/index.html to go directly to the documentation of the api.

#### Running in Heroku
Visit: https://fitbod-zaffalon.herokuapp.com/api-docs/index.html to go directly to the documentation of the api.


# Test coverage report

You can open on the browser the test coverage report:

```
coverage/index.html
```

