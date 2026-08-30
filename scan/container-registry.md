# GitLab Container Registry Integration

To enable GitLab Container Registry, add the following configuration to the GitLab container in `docker-compose.yml`:

```yaml
environment:
  GITLAB_OMNIBUS_CONFIG: |
    external_url 'https://gitlab.example.com'

    registry_external_url 'https://registry.example.com'

    gitlab_rails['registry_enabled'] = true
    registry['enable'] = true
```

Make sure the Registry hostname is configured in DNS and points to the GitLab server.

After updating the configuration, recreate the GitLab container:

```bash
docker compose up -d
```

Check the Registry from:

**GitLab → Project → Deploy → Container Registry**

After enabling the Registry, GitLab provides predefined CI/CD variables such as:

```text
CI_REGISTRY
CI_REGISTRY_IMAGE
CI_REGISTRY_USER
CI_REGISTRY_PASSWORD
```

These variables can be used in `.gitlab-ci.yml` to login, push, and pull Docker images.

