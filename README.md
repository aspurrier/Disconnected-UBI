# Disconnected-UBI
Create a custom Red Hat UBI configured to pull packages from within a disconnected environment.
Update the UBI with the latest versions of the packages that are installed.

Create a dumb YUM repository server cloned from whatever currently provides your packages.

## Contents
* clone-repos_index.html       --  Example welcome page to the YUM repository service.
* clone-repos.md               --  Instructions for building a YUM repository service.
* clone-repos.sh               --  Builds the YUM repository service.
* Containerfile.example        --  Builds a custom UBI.
* Disconnected_UBI8.md         --  Instructions for building a custom UBI.

