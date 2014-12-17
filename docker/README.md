Heat Standalone Docker Image
============================

This will build an image that runs [Keystone][], the [OpenStack][]
identity service.

[keystone]: http://docs.openstack.org/developer/keystone/
[openstack]: http://openstack.org/

Running the image
=================

If you will only be accessing the service from other containers:

    docker run -d larsks/keystone

If you want to access the service from your docker host:

    docker run -dP larsks/keystone

The `-P` (`--publish-all`) option causes docker to create port
forwardings for all ports `EXPOSE`'d in the Dockerfile.

If you want the Keystone database to persist beyond the lifetime of
the container, you can mount a volume on `/srv/keystone`.  Assuming
that `/srv/keystone` exists on your docker host:

    docker run -d -v /srv/keystone larsks/keystone

Accessing the service from another container
============================================

This example uses my [larsks/keystoneclient][] container, which
contains the `keystone` command line client, some credentials which
match the configuration in the `larsks/keystone` image, and a script
discussed below.

[larsks/keystoneclient]: https://registry.hub.docker.com/u/larsks/keystoneclient/

You can use docker's `--link` option to conveniently access the
keystone container from another container:

    docker run -it \
      --volumes-from keystone \
      --link keystone:keystone larsks/keystoneclient /bin/bash

This inserts an entry into `/etc/hosts` with the name `keystone` and
the ip address of the `keystone` container.

This example also uses `--volumes-from` to expose the keystone log
(and database, etc) for inspection/debugging.

If this is your first time interacting with your keystone container,
you will need to provision and initial `admin` user.  The
`/root/setup-keystone.sh` script included on the image will do that
for you:

    bash-4.2# sh /root/setup-keystone.sh 
    ======================================================================
    Initializing keystone
    ======================================================================

    Creating keystone service.
    Creating keystone endpoint.
    Creating admin tenant.
    Creating admin role.
    Creating admin user.
    Assigning admin user to admin role.

    All done.
    ======================================================================

Once this script is complete, you can use the `/root/keystonerc` file
included in the image to set up your credentials:

    bash-4.2# . /root/keystonerc 
    bash-4.2# keystone service-list
    +----------------------------------+----------+----------+-------------+
    |                id                |   name   |   type   | description |
    +----------------------------------+----------+----------+-------------+
    | ce53e66824a64b0ba88b1ceeece473b9 | keystone | identity |             |
    +----------------------------------+----------+----------+-------------+
    bash-4.2# keystone user-list
    +----------------------------------+-------+---------+-------+
    |                id                |  name | enabled | email |
    +----------------------------------+-------+---------+-------+
    | 5731243d139f42b8bfd96162b75f0573 | admin |   True  |       |
    +----------------------------------+-------+---------+-------+

If things aren't working, take a look at the `keystone` log:

    bash-4.2# tail /srv/keystone/keystone.log

