# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.0 - 2022-10-11

- `Changed` bump golang version from 1.18.0 to 1.19.2
- `Changed` bump base alpine version from 3.15 to 3.16
- `Changed` bump docker version from 20.10.12 to 20.10.18
- `Changed` bump golangci-lint version from 1.45.2 to 1.50.0
- `Changed` bump neon version from 1.5.3 to 1.5.5
- `Changed` bump goreleaser version from 1.4.1 to 1.11.5
- `Changed` bump gopls version from 0.7.5 to 0.9.5
- `Changed` bump delve version from 1.8.0 to 1.9.1
- `Changed` bump changie version from 1.3.0 to 1.9.1
- `Changed` bump github-cli version from 2.4.0 to 2.17.0

## v0.7.1 - 2022-04-09

- `Fixed` bump golangci-lint version from 1.44.0 to 1.45.2 (go 1.18)

## v0.7.0 - 2022-04-02

- `Changed` bump golang version from 1.17.6 to 1.18.0

## v0.6.1 - 2022-03-05

- `Fixed` upgrade versions : Go 1.17.6->1.17.8

## v0.6.0 - 2022-01-28

- `Changed` bump github cli version from 2.0.0 to 2.4.0
- `Changed` bump changie version from 1.0.0 to 1.3.0
- `Changed` bump delve version from 1.7.2 to 1.8.0
- `Changed` bump gopls version from 0.7.1 to 0.7.5
- `Changed` bump svu version from 1.7.0 to 1.9.0
- `Changed` bump goreleaser version from 0.181.1 to 1.4.1
- `Changed` bump venom version from 1.0.0-rc.7 to 1.0.1
- `Changed` bump golangci-lint version from 1.42.1 to 1.44.0
- `Changed` bump docker version from 20.10.9 to 20.10.12
- `Changed` bump golang version from 1.17.2 to 1.17.6
- `Changed` bump debian version from buster to bullseye
- `Changed` bump alpine version from 3.14 to 3.15
- `Fixed` install script for goreleaser and svu

## v0.5.1 - 2021-10-08

- `Added` upgrade versions : Go 1.17->1.17.2, GoReleaser 0.178.0->0.181.1, Delve 1.7.1->1.7.2, Go ModifyTags 1.14.0->1.16.0, Docker Client 20.10.8->20.10.9

## v0.5.0 - 2021-09-09

- `Added` upgrade versions : Go 1.16.5->1.17, Docker 20.10.7->20.10.8, GoPLS 0.7.0->0.7.2, Delve 1.6.1->1.7.1, GolangCI-lint 1.41.1->1.42.1, GoReleaser 0.171.0->0.178.0, GithubCLI 1.11.0->2.0.0, Venom 1.0.0-rc.4->1.0.0-rc.7, SVU 1.4.1->1.7.0, Go ModifyTags 1.13.0->1.14.0, Changie 0.5.0->1.0.0

## v0.4.0 - 2021-06-26

- `Added` upgrade versions : Alpine 3.13->3.14, Go 1.16.4->1.16.5, Docker 20.10.6->20.10.7, GoPLS 0.6.11->0.7.0, Delve 1.6.0->1.6.1, GolangCI-lint 1.40.0->1.41.1, GoReleaser 0.168.0->0.171.0, GithubCLI 1.9.2->1.11.0

## v0.3.1 - 2021-05-12

- `Fixed` regression on alpine image with user profile

## v0.3.0 - 2021-05-12

- `Added` debian flavor
- `Added` 3 stages : go-devcontainer-ci (smallest), go-devcontainer-slim and go-devcontainer (biggest)
- `Changed` instool renamed to up

## v0.2.2 - 2021-05-08

- `Fixed` invalidate cache properly for welcome page

## v0.2.1 - 2021-05-03

- `Fixed` display welcome message gradually
- `Fixed` uncache welcome message after update

## v0.2.0 - 2021-05-02

- `Changed` welcome message will be generated only every 12 hours

## v0.1.0 - 2021-04-25

- `Added` initial version of the project
