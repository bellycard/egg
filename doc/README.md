# Egg

Egg makes it easy to set up a cluster of applications for local development, using the magic of docker.

## Usage

```bash
egg setup
```
Once finished, the services will be running.

### Stopping, Starting, Updating

Most docker compose commands can apply to a single service if you follow the command with the service name (app, db)

```bash
// Pause processes
docker-compose pause
// Unpause processes
docker-compose unpause
// Kill processes, but keep the containers intact.
docker-compose kill
// Start processes from stopped containers.
docker-compose start
// Restart services
docker-compose restart
// Rebuild all changed images, and start in the background.
docker-compose up -d
// List processes
docker-compose ps
// Kill and remove all containers.
docker-compose down
```

### Getting into it
```bash
// Get into a running service
docker-compose exec [service-name] [command]
// ex. docker-compose exec app bash
// >> root@156b321e6ec8:/enterprise-admin#
```

You can run tests, or anything, while inside the container, or run rake tasks and rspec directly without first launching a bash process.
```bash
docker-compose exec app bin/rake db:migrate
docker-compose exec app rspec spec/controllers/api/v2/chains_controller_spec.rb
```

More at [docker compose](https://docs.docker.com/compose/compose-file)