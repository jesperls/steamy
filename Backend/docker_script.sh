
#!/bin/bash

if [ "$1" == "build" ]; then
    echo "Removing old Docker containers..."
    docker rm -f steamy-backend-container
    echo "Building Docker image..."
    docker build -t steamy-backend .
elif [ "$1" == "run" ]; then
    echo "Running Docker container..."
    docker run -d -p 8000:8000 --name steamy-backend-container steamy-backend
elif [ "$1" == "build_and_run" ]; then
    echo "Removing old Docker containers..."
    docker rm -f steamy-backend-container
    echo "Building Docker image..."
    docker build -t steamy-backend .
    echo "Running Docker container..."
    docker run -d -p 8000:8000 --name steamy-backend-container steamy-backend
else
    echo "Usage: docker_script.sh [build|run|build_and_run]"
fi