# GitHub Actions Setup for DHI

Your workflow now logs in to Docker Hub to pull DHI images during the build.

## Required Secrets

Add these to your GitHub repository settings (`Settings` → `Secrets and variables` → `Actions`):

- **DOCKER_USERNAME**: Your Docker Hub username
- **DOCKER_PASSWORD**: Your Docker Hub personal access token (NOT your password)

## Get Docker Hub PAT

1. Go to https://hub.docker.com/settings/security
2. Create a new Personal Access Token
3. Copy the token and add it as `DOCKER_PASSWORD` secret in GitHub

## Verify Setup

After pushing to main, check the Actions tab to confirm:
- ✓ Build step completes without auth errors
- ✓ Image is pushed to ghcr.io/your-username/gym-book-fe:latest
- ✓ Both Docker Hub and GHCR logins succeed
