# Planet4 Robots

This repository is home to the static site at root of P4 Kubernetes clusters for
all environments and deployed using CircleCI:

- DEV:  https://k8s.p4.greenpeace.org
- REL:  https://release.k8s.p4.greenpeace.org
- PRD:  https://master.k8s.p4.greenpeace.org

This repo also uses the Static HELM chart found here:  
https://github.com/greenpeace/planet4-helm-static

---

## Updating Robots
Procedure:
1. Make commit to develop -> CircleCI deploy workflow to develop -> hold
2. Check your dev deployment is successful, to move to prod:
3. In this repository, create and push a new tagged release vX.Y.Z -> CircleCI tag workflow
4. Approve hold in deploy workflow
