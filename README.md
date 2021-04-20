# Planet4 Robots

This repository is home to the static site at root of P4 Kubernetes clusters for
all environments and deployed using CircleCI:

- DEV: `https://www-dev.greenpeace.org`
- REL: `https://www-stage.greenpeace.org`
- PRD: `https://www.greenpeace.org`

This repo also uses the Static HELM chart found here:  
https://github.com/greenpeace/planet4-helm-static

---

## Updating Robots
Procedure:
1. In this repository, create and push a new tagged release vX.Y.Z -> CircleCI tag workflow
2. Make commit to develop of your new tag number -> CircleCI deploy workflow to develop -> hold
3. Check your dev deployment is successful, to move to prod:
4. Approve hold in deploy workflow
