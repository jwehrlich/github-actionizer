# github-actionizer
The missing wrapper for docker-compose and Github action runners

```
Usage: github-actionizer [OPTIONS]

  OPTIONS
    build   : Build the base image (automatically ran with start)
    logs    : Prints logs
    start   : Start the service
    stop    : Stop the service
    version : Current version of this gem
```

## Prerequisites
This gem requires `docker` and `docker-compose` to be installed locally

## Setup / Configuration
By default, the configuration file should be located `${HOME}/actionizer.yaml`. One can use the `--config-path <path/to/config>` to specify an alternative path.

### vim ${HOME}/actionizer.yaml
**Syntax**
```
access_token: <github_access_token>
services:
  <service_name>:
    repo: <github_user>/<repo_name>
    replicas: <number_of_instances>
    labels: <optional: comma_seperated_string_of_labels>
    cpu_limit: <optional: cpu_limit>
    cpu_reservation: <optional: minimum_cpu_reservation>
    memory_limit: <optional: memory_limit>
    memory_reservation: <optional: minimum_memory_reservation>
```

**Example**
```
access_token: ghp_12345abcdefg
services:
  fake_service:
    repo: my/fake_service
    replicas: 1
  fake_service_2:
    repo: my/fake_service_2
    replicas: 4
```

## Using The Service
**Start**
```
# ctrl + c stops the service
github-actionizer start
```

**Start as background service**
```
github-actionizer start -d
```

**Stop background service**
```
github-actionizer stop
```
