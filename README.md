# Zimbra SOAP-Harness Tests

## Introduction

This lets you spin up a Docker container that will run the Zimbra SOAP-harness SanityTest suite against a running ZCS instance.


## Configuration

Copy the file `DOT-env` to `.env` and change the values to be appropriate for the cluster you want to test.

- `DOCKER_NETWORK` - This is the name of the Docker network you want the container that you start up to belong to. You can list all available Docker networks by running the command `docker network ls`.
- `DOCKER_DNS` - This is the IP address of a DNS server that is running in the `DOCKER_NETWORK`.
- `ZIMBRA_HOST` - This is the name of the Zimbra host that will be the target of your SOAP tests.  It's name should be resolvable by the DNS that you specify.
- `ZIMBRA_DOMAIN` - This is the name of the Zimbra domain.
- `ZIMBRA_PASSWORDS` - This is the password for the admin account (and all test accounts that are created).

By the way, the example settings from `DOT-env` are already correct for executing the SOAP test against a cluster running from [docker-zcs-dev-machine](https://github.com/Zimbra/docker-zcs-dev-machine).

## Obtaining the Docker Image

You can either pull the image from [Docker Hub](https://hub.docker.com) or build the image locally. This was last updated on 2017-09-07.

### Pull from Docker Hub

	docker pull zimbra/soap-harness:latest

### Building the Image Locally

Run the `build-image` script to build the image. It will create the image `zimbra/soap-harness:latest`, which you can see by running the `docker images` command.

## Running the SanityTest suite

Execute the `./run-test-suite` script to fire up a container called `soap`.  This will automatically run the `SanityTest` suite then exit.  This script will also provide some output while the test is running so you can see how many tests have completed.  It will automatically exit once the test suite has finished.

The test results will be located in the `results` directory, which is mounted into the `soap` container while it is running.  The next time you run the test suite, if there are old test results in the `results` directory, they will be saved in a date/time stamped *.tgz archive.

## Running individual tests

If you like, you may start up the `soap` container, fully configured, and they connect to it and run individual tests.  To do so, just execute the `./run-image` script. It will perform all of the required intialization and leave the `soap` container running.

At this point you can connect to that container as follows:

	docker exec -it soap bash

You may then run individual tests.  Here is an example:

    STAF LOCAL soap EXECUTE zcs-dev.test ZIMBRAQAROOT /opt/qa/soapvalidator/ DIRECTORY /opt/qa/soapvalidator/data/soapvalidator/SanityTest/AccountLoggerRequest_sanity.xml LOG /results/ SUITE SMOKE

Note the `LOG /results/` portion of the command.  This will cause the test results to be stored in the location as described below.

_Notes:

1. Unlike running the full suite with the `./run-test-suite` command, starting the `soap` container via the `./run-image` command  will _not_ automatically archive the `results` directory.
2. When you are through with the `soap` container just do `docker stop soap` and it will be cleaned up.


### Final output from test

In addition to accumulating the results into the `results` directory, the `run-test-suite` will print out some summary results (timing and pass/fail info) at the end of the run.  Something like this:

    Wed Sep  6 14:06:07 CDT 2017 - Tests finished. 75 minutes and 17 seconds elapsed.
    Results in the ./results directory. Summary:
    Pass  Fail  Exception  Skipped
    196   24    4          5



