@echo off
setlocal

if "%1" == "build" (
    echo Removing old Docker containers...
    docker rm -f steamy-backend-container
    echo Building Docker image...
    docker build -t steamy-backend .
) else if "%1" == "run" (
    echo Running Docker container...
    docker run -d -p 8000:8000 --name steamy-backend-container steamy-backend
) else if "%1" == "build_and_run" (
    echo Removing old Docker containers...
    docker rm -f steamy-backend-container
    echo Building Docker image...
    docker build -t steamy-backend .
    echo Running Docker container...
    docker run -d -p 8000:8000 --name steamy-backend-container steamy-backend
) else (
    echo Usage: docker_script.bat [build|run|build_and_run]
)

endlocal