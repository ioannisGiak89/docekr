## Grails images

# Build
All you need to do is clone the repo navigate to this directory and run

```$ docker build --build-arg grails_version=<grails_version> -t <image_name> .```

where `<grails_version>` the grails version you want to use

# Usage
# with docker compose file

```yaml
version: "3.0"

services:
  web:
    image:  <image_name>
    environment:
      - RUN_APP=false or true
#      For mac users
#      - GRAILS_UID=this should match your uid
#      - GRAILS_GID=this should match your gid
    volumes:
      - ./:/app
      - ~/.gradle/gradle.properties:/home/grails/.gradle/gradle.properties
      - ~/drivers/:/home/grails/drivers/
    network_mode: "host"
```

The provision script will create a grails user for you. You can access the container by running
```bash
$ docker exec -it -u grails <container_name> bash
```
