These files create the docker container which runs the BIND CI line.

### Compiling with this image

List any of the existing BIND books in a variable, then build them in a container:

```sh
books="core stories mim"
registry=registry.gitlab.com
image=bindrpg/config
docker run -it --rm --name texbooks "$registry"/"$image":latest gimme $books
```

Copy the files from the container:

```sh
docker cp -a texbooks:BIND .
```

### Make a new image

```bash
docker login "$registry"
docker build -t "$registry"/"$image" .
docker push "$registry"/"$image"
```

Remember to check the CI files for any required changes.
