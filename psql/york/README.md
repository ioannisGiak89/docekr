## PSQL Image for Development

# Links
You can find the code for this image at
https://github.com/ioannisGiak89/docker/blob/master/psql/york/Dockerfile

# Build
All you need to do is clone the repo navigate to this directory and run

```$ docker build --build-arg psql_version=<psql_version> -t <your_registry>/psql-york:<psql_version> .```

where `<psql_version>` the psql version you want to use

# Available PSQL images
Please see [tags](https://hub.docker.com/r/ioannisgiak89/psql-york/tags/)

# Environment Variables
| Name                 | Description                     | Default               | Mandatory |
| -------------------- | ------------------------------- | --------------------- | --------- |
| POSTGRES_USER        | The main psql user              | -                     |   Yes     |
| POSTGRES_DB          | Database name                   | -                     |   Yes     |
| POSTGRES_PASSWORD    | Main user's password            | -                     |   Yes     |
| SCHEMA               | Schema name to create           | -                     |   Yes     |
| APPLICATION_ROLE     | Application role name to create | -                     |   Yes     |
| APPLICATION_USER_1   | Application user 1              | ${APPLICATION_ROLE}_1 |   No      |
| APPLICATION_USER_PWD | Password for the user 1         | ${POSTGRES_PASSWORD}  |   No      |
| SCHEMA_READ_ROLE     | Schema read role to create      | ${SCHEMA}_read        |   No      |

# Usage (Examples setting mandatory environment variables only)

# with docker compose file

```yaml
version: "3.0"

services:
  db:
    image:  ioannisgiak89/psql-york:<version_tag>
    environment:
      - POSTGRES_DB=my_psql_db
      - POSTGRES_USER=my_psql_user
      - POSTGRES_PASSWORD=my_psql_user_password
      - SCHEMA=my_schema
      - APPLICATION_ROLE=my_app_role
    ports:
      - 5432:5432
# Uncomment this section if you want to create a volume for the data
#    volumes:
#      - pgdata:/var/lib/postgresql/data
#
#volumes:
#  pgdata:
#    driver: local
```

# with `docker run` command

```bash
$ docker run \
    -e POSTGRES_DB=my_psql_db \
    -e POSTGRES_USER=my_psql_user \
    -e POSTGRES_PASSWORD=my_psql_user_password \
    -e SCHEMA=my_schema \
    -e APPLICATION_ROLE=my_app_role \
    -p 5432:5432 \
    ioannisgiak89/psql-york:<version_tag>
```
