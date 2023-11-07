These files make up the docker which runs the BIND CI line.
If you want to change things and upload them, you'll need to sign up to docker.com and use your own username.

```bash
docker login
docker build -t $USERNAME/texbind .
docker push $USERNAME/texbind
```
