# Run Orientation in Docker

## Prerequisites

### Docker & Docker-Compose

See [these instructions](https://docs.docker.com/engine/installation/) to install the
Docker daemon for your platform.

Docker Compose is not mandatory, though it provides you with an easy way to get
you started. See the [installation
instructions](https://docs.docker.com/compose/install/).

### Google OAuth2

Orientation uses Google OAuth2 for authentication. From the [Google Developers
Console](https://console.developers.google.com/), create a project and activate
the _Google+ API_. You'll have to create a client ID and secret. Ensure you
provide a redirect URI corresponding to your setup
(e.g. http://localhost:3000/auth/google_oauth2/callback).

Take careful note of the credentials as we'll need them later.

### Mandrill

The [Mandrill](https://mandrillapp.com) API is used to Notification emails.
Create an API key from the Mandrill application as we'll need it later.

### Secret key base

To verify the integrity of signed cookies such as ones used for user sessions,
Orientation uses a secret token. To generate it:

```
ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
```

### Postgres password

Choose a password for the postgres user (you may use `SecureRandom`), we'll
later provide it to the Orientation app.

## Running Orientation

### Configuring Docker Compose

Docker Compose is a tool used to describe multi-container application in a
single file: `docker-compose.yml`.

We need a container to run the Postgres service, another one to store the data
(a [data volume container](https://docs.docker.com/userguide/dockervolumes/#creating-and-mounting-a-data-volume-container)),
and a third one to actually run the application.

```yaml
# docker-compose.yml
datastore:
  image: postgres
  command: /bin/true
  volumes:
    - /var/lib/postgresql/data
database:
  image: postgres
  command: postgres
  volumes_from:
    - datastore
  environment:
    POSTGRES_PASSWORD: "<The password of the postgres user>"
app:
  image: orientation/orientation
  ports:
    - "3000:3000"
  links:
    - database
  environment:
    DATABASE_NAME: "orientation"
    DATABASE_USERNAME: "postgres"
    ORIENTATION_DOMAIN: "localhost:3000"
    DATABASE_PASSWORD: "<The password of the postgres user>"
    GOOGLE_KEY: "<The client ID>"
    GOOGLE_SECRET: "<The client secret>"
    MANDRILL_USERNAME: "<Your mandrill username>"
    MANDRILL_DOMAIN: "<The sending domain>"
    MANDRILL_API_KEY: "<The API key>"
    SECRET_KEY_BASE: "<The secret key base>"
```

We provide the environment variables for Google OAuth2 and Mandrill as well as
the secret key base to the "app" container. The value of the `DATABASE_PASSWORD`
variable of the "app" container should be identical to value of the
`POSTGRES_PASSWORD` variable of the "database" container.

### Controlling the containers

At first run, we have to create the database and run migrations:

```shell
docker-compose run app rake db:create db:migrate
```

Use the `up` command to launch the containers:

```shell
docker-compose up
```

Hit `CTRL+C` to stop the containers and return the control to the terminal.

If you prefer starting the containers in the background:

```shell
docker-compose up -d
```

You'll then have to use the following command when you'll want to stop the
containers:

```shell
docker-compose stop
```

If you need to remove the containers (please notice that **this command wipes
out the database**):

```shell
docker-compose rm --force
```
