FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y screen wget apt-transport-https gnupg ca-certificates openjdk-21-jdk

# Add minecraft user
RUN useradd -rm -d /home/minecraft -s /bin/bash -U minecraft

# Create controller commands

# Switch to minecraft user
USER minecraft
WORKDIR /home/minecraft

# Set server workdir
RUN mkdir -p /home/minecraft/server
WORKDIR /home/minecraft/server

# Install Paper (currently version 1.20.6)
RUN wget -O /home/minecraft/server/minecraft_server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.6/builds/147/downloads/paper-1.20.6-147.jar

# Generate the server files
RUN java -Xms1G -Xmx4G -jar minecraft_server.jar --nogui

# Update EULA
RUN sed -i 's/eula=false/eula=true/g' eula.txt

# Expose the Minecraft Server port
EXPOSE 25565

# Create minecraft controller commands
RUN mkdir -p /home/minecraft/server/.bin
RUN echo '#!/bin/bash\njava -Xms2G -Xmx4G -jar /home/minecraft/server/minecraft_server.jar --nogui' > /home/minecraft/server/.bin/minecraft-start && chmod +x /home/minecraft/server/.bin/minecraft-start
RUN echo "#!/bin/bash\nscreen -S minecraft -X eval 'stuff \"say SERVER SHUTTING DOWN IN 15 SECONDS...\"\015' && /bin/sleep 15 && screen -S minecraft -X eval 'stuff \"save-all\"\015' && screen -S minecraft -X eval 'stuff \"stop\"\015'" > /home/minecraft/server/.bin/minecraft-stop && chmod +x /home/minecraft/server/.bin/minecraft-stop
RUN echo "#!/bin/bash\nscreen -S minecraft -Dr" > /home/minecraft/server/.bin/minecraft-console && chmod +x /home/minecraft/server/.bin/minecraft-console
ENV PATH="/home/minecraft/server/.bin/:${PATH}"

# Start the server
CMD ["screen", "-S", "minecraft", "-D", "-m", "/home/minecraft/server/.bin/minecraft-start"]
