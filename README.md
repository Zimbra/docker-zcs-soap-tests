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

## Starting a test container

Run the `run-image` script to fire up a container called `soap`.  It will be run in detached mode.  A conventient way to run it is as follows:

	./run-image && docker logs -f soap

It starts quickly and at the end you will see some helpful information:

    ************************************************************************
    If necessary, please execute the following command(s) on your
    mailbox server(s) before running any SOAP harness tests:
      zmlocalconfig -e allow_unauthed_ping=true
      zmmailboxdctl restart
    
    ************************************************************************
    To connect to the soap container run this:
      docker exec -it soap bash
    ************************************************************************
    Example: To run a single test:
    
    STAF LOCAL soap EXECUTE zcs-dev.test ZIMBRAQAROOT /opt/qa/soapvalidator/ DIRECTORY /opt/qa/soapvalidator/data/soapvalidator/MailClient/Tasks/Bugs/bug30544.xml LOG /opt/ SUITE SMOKE
    
    Example: To run all the tests under a specific directory:
    
    STAF LOCAL soap EXECUTE zcs-dev.test ZIMBRAQAROOT /opt/qa/soapvalidator/ DIRECTORY /opt/qa/soapvalidator/data/soapvalidator/MailClient/Tasks/Bugs/ LOG /opt/ SUITE SMOKE
    
    ************************************************************************


At that point you can `C-c` to exit rom the `docker logs -f soap` command.
