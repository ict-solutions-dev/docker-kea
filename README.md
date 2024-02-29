# Kea DHCP Server Docker Image

This repository provides a Dockerfile that builds a Docker image for **Kea DHCP server**.

## Description

The Dockerfile uses **Alpine Linux** as the base image and installs the necessary dependencies. It allows for specifying the Kea version using an argument (`ARG VERSION`). The resulting image comes with support for MySQL and PostgreSQL databases, as well as the OpenSSL cryptographic library for network security purposes. After the build process, the image is cleaned up to reduce size and remove unnecessary components.

The Docker image created from this Dockerfile will contain the Kea DHCP server configured with the desired version. It also sets up the timezone to `Europe/Bratislava`. The image includes the following extra features:

- A Mariadb and PostgreSQL database for storing leases and host reservations.
- The Boost development library for additional C++ source libraries.
- The Log4cplus-devel and autoconf tools for generating configuration scripts.
- The Automake tool for automatically creating Makefile.in files compliant with the GNU Coding Standards.
- The libtool and g++ package for supporting portable compiling and linking.

And also, it removes any unnecessary build dependencies after the installation to keep the image lightweight.

The final result is a production-ready Docker image of the Kea DHCP server that can be used as a service in any system running Docker Engine. This image provides high configurability, compact size, and ready-to-use database feature for lease and host reservation storage.
