# validate-gitlab-ci.nvim

[GIF HERE SHOWING AWESOMENESS]

Plugin that validates `.gitlab-ci.yml` files using GitLab's CI Lint API.

Inspired by https://gitlab.com/calebw/vci-check.

## Prerequisites
- Vim installation with Python support
- Currently using Packer to be installed
- Base domain for the API set in an environment variable called `VAL_GITLAB_CI_DOMAIN`
- PAT (Personal Access Token) with `api` scope set in an environment variable called `VAL_GITLAB_CI_TOKEN`

## Instalation

Follow basic Packer use function:

```
use { 'fcaraujo/validate-gitlab-ci.nvim' }
```

## Usage

Open your `.gitlab-ci.yml` then execute the following command:

```
:ValidateGitLabCI
```

🚀
