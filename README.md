[![Greenpeace](https://circleci.com/gh/greenpeace/planet4-nginx-ingress.svg?style=shield)](https://circleci.com/gh/greenpeace/planet4-robots)

![Planet4](./p4logo.png)
# Planet4 Robots

This repository is home to the static site at root of P4 Kubernetes clusters for
all environments and deployed using CircleCI:

- Develop:           `https://www-dev.greenpeace.org`
- Prod - Release:       `https://www-stage.greenpeace.org`
- Prod - Production:    `https://www.greenpeace.org`

<h1>Important Notes</h1>

This repo is responsible for the following:
- deployment of robots.txt file to Cloudflare as described [here](https://www.cloudflare.com/learning/bots/what-is-robots.txt)
- deployment to dev & prod to host the static site
- generation of certificates for the root site endpoints

***
### Requirements - Internal Only
-   Access to P4 Infra [environment](https://www.notion.so/p4infra/bab9d0b1f2db4d929a59916899d531c1?v=eca7b78e1ae345c6883a9b37c6b76cac)

### Built with
- Custom [static](https://github.com/greenpeace/planet4-helm-static) helm chart

### Deployment

   - In this repository, create and push a new tagged release vX.Y.Z -> CircleCI tag workflow
   - Make commit to develop of your new tag number -> CircleCI deploy workflow to develop -> hold
   - Check your dev deployment is successful, to move to prod:
   - Approve hold in deploy workflow

 ### Infra Documentation
 - External
   - [P4 Gitbook](https://support.greenpeace.org/planet4/infrastructure/intro)
 - Internal use only
   - [P4 Notion](https://www.notion.so/p4infra/Robots-Root-of-K8s-52f77fb48f3e40e086deab98f2de374b)

 ### Contributing
 If your interested in contributing to P4 Infrastructure code please check our our community page [here](https://github.com/greenpeace/planet4).

