<img alt="icon" src=".diploi/icon.svg" width="32">

# React + Vite Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/react-vite)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/react-vite)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-react-vite)](https://diploi.com/component/react-vite)

Want to start a quick demo? Use this link
https://diploi.com/component/react-vite
No account required

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

## Operation

### Getting started

1. In the Dashboard, click **Create Project +**
2. Under **Pick Components**, choose **React + Vite**. Here you can also add a backend framework to create a monorepo app, eg, React+Vite for frontend and Hono for backend
3. In **Pick Add-ons**, you can add one or multiple databases to your app
4. Choose **Create Repository** to generate a new GitHub repo
5. Finally, click **Launch Stack**

For more details, check https://diploi.com/blog/hosting_react_apps

### Development

Will run `npm install` when component is first initialized, and `npm run dev` when deployment is started.

### Production

Builds a production-ready image. The image runs `npm install` and `npm run build` in a GitHub Action during creation.

The generated `/dist` folder is served as a static site using [serve](https://github.com/vercel/serve).

#### ENV

Since Vite embeds environment variables during the build step, we provide two ways to manage ENV values in production builds:

1. For values that are not deployment-dependent, define them in `diploi.yaml` using the [static import syntax](https://docs.diploi.com/reference/diploi-yaml#env). The values are exposed to the `Dockerfile` as `ARG` variables.
2. For values that depend on a specific deployment (such as variables imported from other components in `diploi.yaml`, or configured in the **Options** tab), enable the **runtime build** option.

#### Runtime Build

When runtime build is enabled, `npm run build` is executed again when the container starts. This ensures that environment variables from the running deployment are correctly applied, and that any data loaded from other components can use the internal network.

To enable runtime build, set `__VITE_RUNTIME_BUILD` to `true` in `diploi.yaml`:

```yaml
- name: React + Vite
  identifier: react-vite
  package: https://github.com/diploi/component-react-vite#v19.2.10
  env:
    include:
      - name: __VITE_RUNTIME_BUILD
        value: true
```

## Links

- [Adding React-Vite to a project](https://docs.diploi.com/building/components/react-vite)
- [React documentation](https://react.dev/)
- [Vite documentation](https://vite.dev/)
- [serve documentation](https://github.com/vercel/serve)
