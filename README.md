# FITBOD API Code

API for manage workouts from users using Ruby on Rails 6 and PostgreSql.

For synchronization with multiple devices, we can check for the last persisted workout in the device storage, and search in the API for the workouts after that time (created_at).

Get the last created_at and use this data to send it as a param like last_updated_at = last_workout.created_at.

For the correct synchronization, we can't persist in the device storage response after a record creation so we need to call the workout index URL with the last considered persisted date to receive all the records created after the last persistence.

```
Device 1 | Device 2 | Device 3 | Device 4 |        P is equal Persisted, Using just time for a simple example
01:00 P    01:00 P     01:00 P   01:00 P
02:00 P    02:00 P               04:00
03:00 p
```
Device 4 sent to API the request to persist the workout with time 04:00 then receive the return of this with the ID and not mark this as persisted. Now Device 4 calls the workout index with the last persisted date (last_updated_at = 01:00) and receive all the records after this date being able to persist the results.
```
Device 1 | Device 2 | Device 3 | Device 4 |
01:00 P    01:00 P     01:00 P   01:00 P
02:00 P    02:00 P               02:00 P
03:00 P                          03:00 P
                                 04:00 P
```
This way all the other devices can do the same and become synchronized.

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

# Kubernetes (Minikube)


Run the minikube
```
minikube start
```

Add the nginx-ingress
```
minikube addons enable ingress
```

Command to build docker image inside minikube
```
eval $(minikube docker-env)
```

Build the image inside the project folder
```
docker build . -t fitbod-api
```

Apply kubernetes configurations
```
kubectl apply -f k8s/config 
```

Create the database
```
kubectl apply -f k8s/scripts/rails-create.yml
```

Migrate the database
```
kubectl apply -f k8s/scripts/rails-migrate.yml
```

Run minikube tunnel to see the endpoint
```
minikube tunnel
```

Visit: http://localhost/api-docs/index.html to go directly to the documentation of the api.
