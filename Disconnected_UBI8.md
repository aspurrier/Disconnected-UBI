Create a Disconnected and Updated UBI
=====================================

References
----------

   * https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image

Prerequisite Packages
---------------------

```bash
sudo dnf install buildah podman skopeo vim
```

Build the Updated Image
-----------------------

A Containerfile has been included in this repository.  "build bud" will default to using the _Containerfile_ in the current directory.
The IP Address in the _Containerfile_ need to be replaced with your YUM repo server.

```bash
buildah bud -t spud_ubi8 .
```

Test Run a Container
--------------------

```bash
podman run -it --name spud_ubi8 localhost/spud_ubi8 bash

# ... do test stuff inside the container ...

podman rm spud_ubi8
```

Upload Image to Registry
------------------------

Use skopeo to copy the image to a registry.


Delete the Image / Clean Up
---------------------------

```bash
podman rmi localhost/spud_ubi8
```

