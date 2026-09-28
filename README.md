<img alt="icon" src=".diploi/icon.svg" width="32">

# React + Vite Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/react-vite)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/react-vite)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-react-vite)](https://diploi.com/component/react-vite)

Launch a trial, no account needed
https://diploi.com/component/react-vite

Uses the official [node](https://hub.docker.com/_/node) Docker image.

A minimal setup to get React working in Vite with HMR and some [Oxlint](https://oxc.rs/docs/guide/usage/linter) rules, based on the `react-ts` template of [create-vite](https://vite.dev/guide/#scaffolding-your-first-vite-project). React is compiled with [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/tree/main/packages/plugin-react), which uses [Oxc](https://oxc.rs).

## Operation

### Getting started

1. In the Dashboard, click **Create Project +**
2. Under **Pick Components**, choose **React + Vite**

   You can add other frameworks from this page if you want to build a monorepo application, eg, React + Vite for the frontend and Hono for the backend.
3. In **Pick Add-ons**, select any databases or extra tools you need.
4. Choose **Create Repository** so Diploi generates a new GitHub repo for your project.
5. Click **Launch Stack**

Prefer the full guide? Check https://diploi.com/blog/hosting_react_apps

### Package managers

Supports **Bun**, **Yarn**, **npm**, and **pnpm**. The package manager is auto-detected from your lockfile (`bun.lock`, `yarn.lock`, `package-lock.json`, or `pnpm-lock.yaml`). The install and build steps always use the detected package manager.

### Development

When the component is first initialized, dependencies are installed using the detected package manager. The Vite development server is then started with:

```sh
npm run dev -- --host
```

This can be changed with the `containerCommands.developmentStart` field in `diploi.yaml`.

### Production

Builds a production-ready image. Image runs `npm install` & `npm run build` when being created, using the detected package manager. `npm run build` type-checks the project with `tsc -b` before `vite build` writes the app to `dist/`.

The `dist/` folder is served as a static site using [serve](https://github.com/vercel/serve):

```sh
serve -s -l 5173 dist
```

This can be changed with the `containerCommands.productionStart` field in `diploi.yaml`.

#### ENV

Vite replaces [`import.meta.env.VITE_*`](https://vite.dev/guide/env-and-mode) with the values of those environment variables during the build step. Only variables with the `VITE_` prefix are exposed to your code, and everything they contain is visible in the browser, so never give a secret a `VITE_` name.

We provide two ways to manage ENV values in production builds:

1. For values that are not deployment-dependent, define them in `diploi.yaml` using the [static import syntax](https://docs.diploi.com/reference/diploi-yaml#env). The values are exposed to the `Dockerfile` as `ARG` variables.
2. For values that depend on a specific deployment (such as variables imported from other components in `diploi.yaml`, or configured in the **Environment** tab), enable the **runtime build** option.

To use a variable from another component in your code, import it under a name with the `VITE_` prefix. For example, to call the public address of a backend with the `api` identifier:

```yaml
- name: React + Vite
  identifier: react-vite
  package: https://github.com/diploi/component-react-vite#v19.3.0
  env:
    include:
      - api.APP_ENDPOINT:VITE_API_URL
```

Your code runs in the browser, so use the public `<HOST>_ENDPOINT` address of a component. The `<HOST>_INTERNAL_ENDPOINT` address only works inside the deployment.

#### Runtime Build

When runtime build is enabled (which it is by default), `npm run build` is executed again when the container starts. This ensures that environment variables from the running deployment are correctly applied, and that any data loaded from other components can use the internal network.

To disable runtime build, set `__VITE_RUNTIME_BUILD` to `false` in `diploi.yaml`:

```yaml
- name: React + Vite
  identifier: react-vite
  package: https://github.com/diploi/component-react-vite#v19.3.0
  env:
    include:
      - name: __VITE_RUNTIME_BUILD
        value: false
```

#### Ports

The component serves on port **5173** in both development and production. If you change it, update all of these so they stay in sync:

- `hosts[].port` in `diploi.yaml`
- `EXPOSE` in `Dockerfile` and `Dockerfile.dev`
- `ENV PORT` and the `-l` option of `serve` in `Dockerfile`
- `server.port` in `vite.config.ts`, which the development server uses. It is not set, because 5173 is the Vite default

## Links

- [Adding React + Vite to a project](https://docs.diploi.com/building/components/react-vite)
- [React documentation](https://react.dev/)
- [Vite documentation](https://vite.dev/)
- [Oxlint documentation](https://oxc.rs/docs/guide/usage/linter)
- [serve documentation](https://github.com/vercel/serve)
