# Drone-Buildah

A plugin for Drone-CI that uses Buildah to build and push OCI images.

```yaml
type: pipeline
kind: docker

steps:
- name: build
  image: mattdavis90/drone-buildah
  settings:
    repo: myregistry.com/user/example
    tags:
     - latest
    username: user
    password:
      from_secret: docker_password
    target: build
    dockerfile: Dockerfile
    insecure: true
    autotag: true
```
