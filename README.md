# Containerized Github Action Runner
Scripts providing a containerized ephemeral action runner for the `mattbucknall-oss` GitHub organization.

A runner container performs the following actions:

- Registers new runner with the GitHub organization.
- Listens for a new job as a non-root user in a clean environment devoid of tokens.
- Executes job.
- Removes runner from GitHub organization.
- Terminates.

## NOTE:
An `env.list` file must be created in this directory containing:

```
GH_ORG=<Name of GitHub organization>
GH_PERSONAL_ACCESS_TOKEN=<PAT with scope to register/remove runners from organization>
```

Ensure `env.list` is created with only 0600 or 0400 permissions!
