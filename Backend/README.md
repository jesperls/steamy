# Backend

This is the backend for the Steamy project, built with FastAPI.

## Requirements

- Python 3.7+
- FastAPI
- Docker (optional, for containerization)

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/jesperls/steamy.git
    cd steamy/Backend
    ```

2. Create a virtual environment and activate it:

    On Unix-based systems:
    ```sh
    python -m venv venv
    source venv/bin/activate
    ```

    On Windows:
    ```bat
    python -m venv venv
    venv\Scripts\activate
    ```

3. Install the dependencies:
    ```sh
    pip install -r requirements.txt
    ```

## Running the Application

1. Start the FastAPI server:
    ```sh
    uvicorn main:app --reload
    ```

2. Open your browser and navigate to `http://127.0.0.1:8000/docs` to see the interactive API documentation.

## Docker

To run the application using Docker:

1. Use the provided scripts to build, run, or build and run the Docker container:

    On Windows:
    ```bat
    docker_script.bat build
    docker_script.bat run
    docker_script.bat build_and_run
    ```

    On Unix-based systems:
    ```sh
    ./docker_script.sh build
    ./docker_script.sh run
    ./docker_script.sh build_and_run
    ```

2. Open your browser and navigate to `http://127.0.0.1:8000/docs` to see the interactive API documentation.