# API Rate Limiter

## Project Overview

The API Rate Limiter is a backend solution designed to manage and enforce rate limits on API requests. By controlling the rate of incoming requests, it prevents abuse, ensures fair usage, and optimizes server performance. This solution employs rate limits at various time intervals (second, minute, and hour) to enforce usage restrictions.

This project is implemented in Motoko and deployed on the Internet Computer (IC) ecosystem. It includes features such as client registration, request logging, and real-time usage tracking.

## Features

- **Client Registration**: Clients can register with the API to obtain a unique API key.
- **Rate Limiting**: Limits are enforced for the number of requests a client can make per second, minute, and hour.
- **Request Logging**: Every API request made by a client is logged with a timestamp.
- **Usage Tracking**: Clients can check their usage in terms of requests made in the last second, minute, and hour.
- **Rate Limit Enforcement**: The system checks if a client’s request rate exceeds the specified limits before processing their request.
- **Log Compression**: Old logs beyond the last hour are periodically removed to optimize storage.

## Technologies Used

- **Motoko**: A programming language for developing applications on the Internet Computer.
- **Internet Computer (IC)**: A decentralized blockchain network for building decentralized applications.

## How It Works

1. **Client Registration**: When a new client registers, they receive a unique API key.
2. **Request Logging**: Every time a client makes a request, it is logged along with the timestamp.
3. **Rate Limit Checking**: Each request is checked against the rate limits (requests per second, minute, and hour). If the limits are exceeded, the request is rejected.
4. **Usage Tracking**: Clients can query the system to see how many requests they have made in the past second, minute, and hour.
5. **Log Compression**: Logs older than one hour are removed periodically to save storage.

## API Endpoints

- **POST `/registerClient`**: Registers a new client and returns a unique API key.
- **POST `/handleRequest`**: Processes an API request after checking rate limits. Returns an error message if rate limits are exceeded.
- **GET `/checkUsage`**: Checks the number of requests made in the last second, minute, and hour for a given API key.
- **POST `/compressLogs`**: Compresses old request logs that are older than one hour.

## Setup

### Prerequisites

- [Motoko](https://www.internetcomputer.org/docs/current/motoko/) programming environment
- [Internet Computer SDK](https://sdk.dfinity.org/docs/index.html)

### Installation

1. Clone the repository to your local machine.
2. Follow the instructions in the [Internet Computer SDK documentation](https://sdk.dfinity.org/docs/index.html) to set up your environment.
3. Deploy the project to the Internet Computer using the Motoko framework.

### Running the Application

Once the application is deployed on the Internet Computer, you can interact with the API using the provided endpoints to register clients, handle requests, and track usage.

## Contributing

Contributions are welcome! If you have suggestions or improvements for the project, feel free to open an issue or create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
