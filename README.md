# Configuration

## Organization and access token

In docker-compose.yml file, configure ORG and TOKEN environment variables.

* `ORG` is the name of the organization you want to add the runners to (`ULE-Informatica-2023-2024` for example).
* `TOKEN` is a Fine-grained personal access token, owned by the organization and with read/write access to the `Self-hosted runners` permission.

## Replicas and resources

Adjust docker-compose.yml deploy section in order not to exceed the capacities of the server where the runners are to be deployed.

* `replicas` is the total number of runners to be created.
* `limits` section prevents the container to allocate more. `reservations` section guarantee the container can allocate at least the configured amount.
    * `cpus` in number of cores.
    * `memory` the amount of memory.


# Run

```
$ docker compose up -d
```