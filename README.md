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

## Deploying the Helm Chart

1. Set up a minikube cluster locally
2. Make sure the cluster is up and running
3. Install helm
4. Go to the root directory of the code repository and run helm package to make a .tgz file that will be used to deploy the kubernetes resources
```bash
helm package todoapi-helmchart
```
5. Run helm install on the previuosly generated file to push the resources to the k8s cluster (in this case minikube)
```bash
helm install todoapi-test .\todoapi-helmchart-0.1.0.tgz
```
6. To get the service IP and port run the following:
```bash
minikube service todoapi-svc --url
```
this should return the node IP and the port which we can use to send the http requests to the backend app that is running on the cluster
7. By using the url (ex. http://172.19.x.x:32380/todoitems) we can communicate with the pods that are running the image and can send requests to the app.

## EXPLANATION OF THE GITHUB ACTIONS PIPELINE

This file automates the build, testing, and deployment process for the ToDo API application, including Docker image creation, Kubernetes deployment, and endpoint testing. Make sure to set up appropriate secrets and configurations before running the pipeline.

- The pipeline runs whenever a new tag starting with 'v' is pushed to the repository.

Build: This job runs on an Ubuntu environment.

Steps:

- Checkout Repository: Clones the repository.
- Set up Docker Buildx: Configures Docker Buildx.
- Login to Docker Hub: Authenticates with Docker Hub using previously set up credentials (You need to set up a GitHub Actions secret DOCKER_USERNAME and DOCKER_PASSWORD with your dockerhub credentials before running the pipeline)
- Determine Version: Extracts the version from the Git tag (that starts with v*).
- Restore NuGet Packages: Restores NuGet packages for the C# project.
- Build and Publish: Builds and publishes the C# project in Release mode.
- SonarQube Analysis: Runs code analysis using SonarCloud.
- Build Docker Image: Builds a Docker image using the project version.
- Push Docker Image: Pushes the Docker image to Docker Hub.
- Install Helm: Installs Helm for Kubernetes.
- Start Minikube: Initializes Minikube from an existing code from Actions marketplace.
- Testing k8s Cluster: Precheck for Kubernetes cluster accessibility.
- Install Curl: Installs Curl for HTTP requests.
- Package Helm Chart: Packages the Helm chart for deployment.
- Helm Install: Installs the previously packaged Helm chart onto the Kubernetes cluster.
- Wait for Resources to be Created: Allows time for Kubernetes resources to be created.
- Get Node IP and Port Number: Retrieves the Node IP and port number for the deployed service.
- Test Endpoints (POST and GET): Sends test requests to the deployed endpoints using Curl.
