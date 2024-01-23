These files create the docker container which runs the BIND CI line.

### Compiling with this image

List any of the existing BIND books in a variable, then build them in a container:

```bash
books="core stories mim"
docker run -it --rm --name texbooks andonome/texbind:latest gimme $books
```

Copy the files from the container:

```bash
docker cp -a texbooks:BIND .
```

### Make a new image

```bash
docker login
docker build -t $USERNAME/texbind .
docker push $USERNAME/texbind
```
...then change the CI file to match your username.
