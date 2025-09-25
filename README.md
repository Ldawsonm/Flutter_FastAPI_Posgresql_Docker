# USDA Food Search App

## Overview

This app is a fork from a [Flutter+FastAPI+PostgreSQL Docker Compose template](https://github.com/AlankritNayak/Flutter_FastAPI_Posgresql_Docker)

In this app, you may search for foods and find different brands and variations of the food.

## TechStack
- Flutter: For frontend UI
- FastAPI: For backend rest api
- NGINX: To serve the Frontend
- PostgreSQL: as a SQL database

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Flutter](https://docs.flutter.dev/install)

### Installation and Running

1. **Clone the Repository**

    ```bash
    git clone https://github.com/Ldawsonm/Flutter_FastAPI_Posgresql_Docker.git
    cd Flutter_FastAPI_Posgresql_Docker
    ```

2. **Build the Flutter App**

    In the root directory of the front end, run:
    ```bash
    flutter build web --release
    ```

3. **Build and Run with Docker Compose**

    In the root directory of the project, where the `docker-compose.yml` file is located, run:

    ```bash
    docker-compose up --build
    ```

    This command will build and start all the services defined in `docker-compose.yml`.

4. **Accessing the Application**

    - **Backend (FastAPI)**: The backend API will be accessible at `http://localhost:8008`.
    - **Frontend (Flutter Web App)**: The frontend application will be accessible at `http://localhost:8080`.
    - **Swagger Docs**: `http://localhost:8008/docs`
