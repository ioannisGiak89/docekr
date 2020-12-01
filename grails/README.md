## Tomcat images

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
      - BUILD_APP=false or true
      - CONTEXT_BASE_FILE_NAME=itsapp#staff
      - CONTEXT_PATH=\/itsapp\/staff
      - APP_ENV=DEVELOPMENT
#      For mac users
#      - GRAILS_UID=this should match your uid
#      - GRAILS_GID=this should match your gid
    volumes:
      - ./:/app
      - ~/.gradle/gradle.properties:/home/grails/.gradle/gradle.properties
      - ~/drivers/:/home/grails/drivers/
    network_mode: "host"
```
