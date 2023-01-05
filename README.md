# DreamBook

## Architecture

![Architecture Diagram](readme-images/Architecture%20DreamBook.drawio.svg "Architecture Diagram")

This project uses [Google Cloud Platform](https://cloud.google.com/), with infrastructure provisioned from code with [Terraform](https://www.terraform.io/).

- `/backend/init` maintains infrastructure needed to set up the Terraform state bucket for the rest of the infrastructure.
- `/backend/terraform` maintains all other infrastructure.

The only non-managed resources are provided by Firebase (used for database, hosting and authentication).
Steps that need to be performed:

1. Run `terraform init` and `terraform apply` in `/backend/init` to create the Terraform state bucket.
   - Note: A number of applies may be needed, as Google Cloud APIs are enabled asynchronously.
2. Run `terraform init` and `terraform apply` in `/backend/terraform` to create the rest of the infrastructure.
   - Note: The service account `terraform-applier` must be used for Firebase Auth resources, but it has limited access for security.
     The service account must be created first along with the rest of the resources by an admin user using `terraform apply`.
   - `terraform apply` takes `worker_image_tag` as an input, which is the tag of the Docker image to deploy to the worker agent.
     The image must be built and pushed to the Google Container Registry first.
3. Using the [Firebase CLI](https://firebase.google.com/docs/cli), run `firebase init` in `/frontend` to set up a Firebase project.
4. In the [Firebase Console](https://console.firebase.google.com/), enable the following services for the project:
   - Authentication
   - Cloud Firestore
   - Hosting
5. Enable Google as a sign-in provider in the Firebase Console. Add desired domains to Authorized Domains.

### Frontend

The frontend (`/frontend`) is an SPA (single-page application) using [React](https://reactjs.org/) and [TypeScript](https://www.typescriptlang.org/), with [Vite](https://vitejs.dev/) for bundling. It is hosted on [Firebase](https://firebase.google.com/docs/hosting), which is also used for [authentication](https://firebase.google.com/docs/auth).

### Backend

The [cloud function](https://cloud.google.com/functions) (`/backend/cloud_function`) handles user requests originating from the frontend. It creates and assigns tasks to the worker agents with GPUs, by publishing messages to the [Pub/Sub](https://cloud.google.com/pubsub) topic `worker-agent-requests`.

The number of worker agents is fixed to the number of unacknowledged messages in this Pub/Sub topic, managed by the autoscaler.

The worker agent (`/backend/worker_agent`) also retrieves the task specification from the Pub/Sub topic.

The worker agent script and cloud function are both written in [Python](https://www.python.org/).

### CI/CD

[GitHub Actions](https://docs.github.com/en/actions) (`.github/workflows`) are used for continuous delivery, deploying both frontend and backends on every merge to the `main` branch.

Keyless authentication with Google Cloud is achieved using [a Workload Identity Pool](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).
