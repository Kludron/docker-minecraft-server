# Docker Paper Minecraft Server

## Quickstart
1. Clone the repository
```
git clone https://github.com/kludron/docker-minecraft-server && cd docker-minecraft-server
```
2. Build the Dockerfile
```
docker build . -t paper-minecraft-server
```
3. Run the built docker container
```
docker run -d --rm minecraft-server -p 25565:25565 paper-minecraft-server
```

The minecraft server should now be available through connecting to `localhost` through the Minecraft multiplayer screen (this is local to your device only).

### Connecting to the console
You can view the console through the docker's `minecraft-console` command, which can be run with 
```
docker exec -it minecraft-server minecraft-console
```
This connects to the [`screen`](https://ss64.com/bash/screen.html) instance, so normal commands apply here (i.e. `control-a, d` to disconnect from the instance).

You can also stop the minecraft server by running the docker `minecraft-stop` command, which can be run with 
```
docker exec -it minecraft-server minecraft-stop
```

## Creating a persistent image
This can be done through the command line, by utilising the provided example `docker compose` [docker-compose.yaml](/docker-compose.yaml) file. This example file creates a `server` file that is external to the docker image so that plugins, and other manual changes can be made easily by simple updating the relevant files, and restarting the docker container.
