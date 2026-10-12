# App of Apps demo

One Argo CD `Application` (the **root**) creates all the other Applications.
Every application is deployed with the **same Helm chart**; only its values file differs.

```
charts/app/              # generic Helm chart (Deployment + Service)
apps/<name>/values.yaml  # per-application settings: image, port, env, replicas
argocd/root.yaml         # the app of apps - the only thing you apply by hand
argocd/apps/<name>.yaml  # one child Application per app (chart + that app's values)
```

```
root ──> argocd/apps/ ──> nginx   ─┐
                      ──> whoami  ─┼─> charts/app + apps/<name>/values.yaml
                      ──> podinfo ─┘
```

## Bootstrap

```sh
kubectl apply -f argocd/root.yaml
kubectl get applications -n argocd
```

## Open the Argo CD UI

```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
# https://localhost:8080  user: admin
```

## Try the apps

```sh
kubectl port-forward svc/podinfo -n podinfo 9898:80   # http://localhost:9898
kubectl port-forward svc/whoami  -n whoami  8081:80   # http://localhost:8081
kubectl port-forward svc/nginx   -n nginx   8082:80   # http://localhost:8082
```

## Exercises

1. **Change an app:** edit `apps/podinfo/values.yaml` (e.g. `PODINFO_UI_MESSAGE` or `replicaCount`), push, and watch Argo CD sync.
2. **Add an app:** create `apps/<new>/values.yaml`, copy `argocd/apps/nginx.yaml` to `argocd/apps/<new>.yaml` and replace the name. Push, and the root app creates it.
3. **Remove an app:** delete its file from `argocd/apps/`. Push, and the root prunes the Application and its resources.
4. **Self-heal:** `kubectl delete deploy whoami -n whoami` and watch Argo CD bring it back.
