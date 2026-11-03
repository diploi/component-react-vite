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

Supports **Bun**, **Yarn**, **npm**, and **pnpm**. The package manager is the one `packageManager` in your `package.json` names, or else the one your lockfile belongs to (`bun.lock`, `pnpm-lock.yaml`, `yarn.lock` or `package-lock.json`). The install and build steps always use it, at the version `packageManager` names.

### Development

When the component is first initialized, dependencies are installed using the detected package manager. The Vite development server is then started with:

```sh
npm run dev -- --host
```

This can be changed with the `containerCommands.developmentStart` field in `diploi.yaml`.

### Production

Staging and production build the deployment's commit on the deployment itself, with the deployment's environment variables: dependencies are installed with the detected package manager, then `npm run build` type-checks the project with `tsc -b` before `vite build` writes the app to `dist/`. A commit is built once; a restart of the component reuses the build. A failed build leaves the previous version running, and its log is shown on the deployment page, where the commit can also be built again.

The `dist/` folder is served as a static site using [serve](https://github.com/vercel/serve):

```sh
serve -s -l $PORT dist
```

This can be changed with the `containerCommands.productionStart` field in `diploi.yaml`. See [Ports](#ports).

In staging and production the project folder is read-only while `serve` runs. The app runs in the browser and writes no files: data it keeps belongs in another component, such as a backend with a database.

#### ENV

Vite replaces [`import.meta.env.VITE_*`](https://vite.dev/guide/env-and-mode) with the values of those environment variables during the build step. Only variables with the `VITE_` prefix are exposed to your code, and everything they contain is visible in the browser, so never give a secret a `VITE_` name.

The build runs with every environment variable of the deployment: the static values in `diploi.yaml`, the ones imported from other components and the ones set in the **Environment** tab. A changed value builds the commit again.

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

#### System packages

The image has no packages beyond Node.js, Bun and pnpm. Install more with `initScript` in `diploi.yaml`, which runs as root when the component starts, or `preBuildScript`, which runs only before the build:

```yaml
- name: React + Vite
  identifier: react-vite
  package: https://github.com/diploi/component-react-vite#v19.3.0
  preBuildScript: |
    apt-get update && apt-get install -y --no-install-recommends python3 make g++
```

#### Ports

The component serves on port **5173** in every stage. To use another one, change the `port` of its `app` host in `diploi.yaml` (`hosts: [{ identifier: app, port: 8080 }]`). Diploi passes that port to the app as the `PORT` environment variable, and both the development server (`server.port` in `vite.config.ts`) and `serve` in staging and production listen on it.

A `containerCommands.productionStart` of your own should listen on `$PORT` too, for example `serve -s -l $PORT dist`. Staging and production count a new version as ready once it accepts connections on that port: one that listens elsewhere never becomes ready, and the previous version keeps serving.

## Links

- [Adding React + Vite to a project](https://docs.diploi.com/building/components/react-vite)
- [React documentation](https://react.dev/)
- [Vite documentation](https://vite.dev/)
- [Oxlint documentation](https://oxc.rs/docs/guide/usage/linter)
- [serve documentation](https://github.com/vercel/serve)
