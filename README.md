# DreamBook

## Architecture

![Architecture Diagram](readme-images/Architecture%20DreamBook.drawio.svg "Architecture Diagram")

This project uses Google Cloud Platform, with infrastructure provisioned from code with Terraform.

- `/backend/init` maintains infrastructure needed to set up the Terraform state bucket for the rest of the infrastructure.
- `/backend/terraform` maintains all other infrastructure.

The only non-managed resources are provided by Firebase (used for database, hosting and authentication).

### Frontend

The frontend (`/frontend`) is an SPA (single-page application) using React + TypeScript, with Vite for bundling. It is hosted on Firebase, which is also used for authentication.

### Backend

The cloud function (`/backend/cloud_function`) handles user requests originating from the frontend. It creates and assigns tasks to the worker agents with GPUs, by publishing messages to the Pub/Sub topic `worker-agent-requests`.

The number of worker agents is fixed to the number of unacknowledged messages in this Pub/Sub topic, managed by the autoscaler.

The worker agent (`/backend/worker_agent`) also retrieves the task specification from the Pub/Sub topic.

The worker agent script and cloud function are both written in Python.

### CI/CD

GitHub Actions (`.github/workflows`) are used for continuous delivery, deploying both frontend and backends on every merge to the `main` branch.
Keyless authentication with Google Cloud is achieved using [a Workload Identity Pool](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).
