# GitLab Runner Setup with Docker


---

## 1. Create a Docker Volume

A persistent Docker volume is created to store the GitLab Runner configuration.

```bash
docker volume create gitlab-runner-config
```

Verify the volume:

```bash
docker volume ls
```

---

## 2. Start GitLab Runner Container

The official GitLab Runner image is used to deploy the Runner:

```bash
docker run -d \
  --name gitlab-runner \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v gitlab-runner-config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```

### Configuration

The following options are used:

| Option                        | Description                                             |
| ----------------------------- | ------------------------------------------------------- |
| `-d`                          | Run the container in detached mode                      |
| `--name gitlab-runner`        | Name the container                                      |
| `--restart always`            | Automatically restart the container                     |
| `/var/run/docker.sock`        | Allows the Runner to communicate with the Docker daemon |
| `gitlab-runner-config`        | Persists Runner configuration                           |
| `gitlab/gitlab-runner:latest` | Official GitLab Runner image                            |

Verify that the container is running:

```bash
docker ps
```

Expected output should contain:

```text
gitlab-runner
```

---

## 3. Register the Runner

The Runner is registered with the GitLab project using the Project Registration Token.

Run:

```bash
docker exec -it gitlab-runner gitlab-runner register
```

During the registration process, provide the following:

```text
GitLab instance URL:
https://<my-domain>

Registration token:
<project-token>

Runner description:
automation-runner

Executor:
docker

Default Docker image:
docker:latest
```

> **Security:** The registration token is sensitive information and must not be committed to the repository or included in this documentation.

---

## 4. Verify Runner Registration

List the configured Runners:

```bash
docker exec gitlab-runner gitlab-runner list
```

Verify the Runner:

```bash
docker exec gitlab-runner gitlab-runner verify
```

Expected result:

```text
Verifying runner... is alive
```

---

## 5. Check Runner Configuration

The Runner configuration is stored inside the container at:

```text
/etc/gitlab-runner/config.toml
```

It can be inspected using:

```bash
docker exec gitlab-runner cat /etc/gitlab-runner/config.toml
```

The configuration should contain the Docker executor:

```toml
[[runners]]
  name = "automation-runner"
  executor = "docker"

  [runners.docker]
    image = "docker:latest"
```

---

## 6. Verify Docker Executor

The Runner uses the Docker executor to execute GitLab CI/CD jobs inside Docker containers.

The Docker socket is mounted into the Runner container:

```text
/var/run/docker.sock:/var/run/docker.sock
```

This allows the GitLab Runner to create and manage job containers using the host Docker daemon.

---

## 7. Verify Runner in GitLab

The Runner can be verified from the GitLab project:

```text
Project
→ Settings
→ CI/CD
→ Runners
```

The Runner should appear as:

* **Active**
* **Online**
* **Green**

The executor should be:

```text
Docker
```


---

## Final Status

| Task                                     | Status      |
| ---------------------------------------- | ----------- |
| GitLab Runner deployed using Docker      | ✅ Completed |
| Runner registered with GitLab            | ✅ Completed |
| Docker executor configured               | ✅ Completed |
| Default Docker image configured          | ✅ Completed |
| Runner container running                 | ✅ Completed |
| Runner verified                          | ✅ Completed |
| Runner visible as Green/Active in GitLab | ✅ Completed |

## Conclusion

The GitLab Runner has been successfully deployed as a Docker container on the Linux server.

The Runner is registered with the GitLab project and configured with the Docker executor. It is active and ready to execute CI/CD jobs for the automation engine.

