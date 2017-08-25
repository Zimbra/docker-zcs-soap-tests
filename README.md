# Zimbra SOAP-Harness Tests

## Introduction

This let's you spin up a Docker container from which you can execute SOAP harness tests
against an external Zimbra instance.

## Configuration

Copy the file `DOT-env` to `.env` and change the values to be appropriate for the cluster you
want to test.

- `DOCKER_NETWORK` - This is the name of the Docker network you want the container that you start up to belong to. You can list all available Docker networks by running the command `docker network ls`.
- `DOCKER_DNS` - This is the IP address of a DNS server that is running in the `DOCKER_NETWORK`.
- `ZIMBRA_HOST` - This is the name of the Zimbra host that will be the target of your SOAP tests.  It's name should be resolveable by the DNS that you specify.
- `ZIMBRA_DOMAIN` - This is the name of the Zimbra domain.
- `ZIMBRA_PASSWORDS` - This is the password for the admin account (and all test accounts that are created).

## Building the Image

Run the `build-image` script to build the image. It will create the image `zimbra/soap-harness:latest`, which you can see by running the `docker images` command.

## Running the SanityTest suited

Run the `run-image` script to fire up a container called `soap`.  This will automatically run the `SanityTest` suite then exit.

	./run-image

There is no output to the terminal until the test is finished. However you can see results accumulate in the `results` directory, which is mounted into the `soap` test container.
