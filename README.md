# dotnet-todo

## Test the GET endpoints

Test the app by calling the endpoints from a browser or Postman. The following steps are for Postman.

  Create a new HTTP request.
  Set the HTTP method to GET.
  Set the request URI to https://localhost:<port>/todoitems. For example, https://localhost:5001/todoitems.
  Select Send.

The call to GET /todoitems produces a response similar to the following:

```json
[
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
]
```

  Set the request URI to https://localhost:<port>/todoitems/1. For example, https://localhost:5001/todoitems/1.

  Select Send.

  The response is similar to the following:

```json
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
```

This app uses an in-memory database. If the app is restarted, the GET request doesn't return any data. If no data is returned, POST data to the app and try the GET request again.

## Build and Run the Docker image

### Notes
The Dockerfile uses Alpine Linux as the base image for a lightweight container.
It installs necessary dependencies using apk.
It installs the .NET 8.0 runtime using dotnet-install.sh.
The application is copied into the /app directory inside the container.
The container exposes port 5555, which is the port the TodoApi application listens on.
The entrypoint command starts the TodoApi application using dotnet.


To build the Docker image, execute the following command in the directory containing the Dockerfile:

```bash
docker build -t todoapi:latest .
```

To run the Docker container, execute the following command:

```bash
docker run -d -p 5555:5555 --name todoapi todoapi:latest
```

This will start the TodoApi application inside a Docker container, exposing it on port 5555 of your host machine.

You can verify that the application is running by sending a GET request to http://localhost:5555/todoitems. If the container was started for the first time the call will return an empty response. In order to populate the in-memory DB with dummy data run a POST request to http://localhost:5555/todoitems with a body:

```json
  {
    "name": "walk dog",
    "isComplete": false
  }
```

