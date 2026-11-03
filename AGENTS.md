# React + Vite

A client-side [React](https://react.dev/) app built with [Vite](https://vite.dev/), from the `react-ts` template of
`create-vite`.

## This component

- There is no server code and no SSR. Staging and production serve the static build in `dist/` with `serve -s`,
  which answers unknown paths with `index.html`, so client-side routing works. Anything that needs a server, a secret
  or a database belongs in another component.
- Listens on `PORT`, which Diploi sets to the port of the `app` host in `diploi.yaml` (**5173** unless changed): the
  development server through `server.port` in `vite.config.ts`, and `serve -s -l $PORT dist` in staging and
  production. To change the port, change only the host's `port`. Never hardcode one: staging and production count a
  version as ready once it accepts connections on `PORT`, and one that listens elsewhere never becomes ready.
- Development runs `npm run dev -- --host`. Staging and production build the commit with `npm run build`, which is
  `tsc -b && vite build`, so a type error fails the build.
- The development server already allows the Diploi hosts. Add any other host to `server.allowedHosts` in
  `vite.config.ts`, and never set it to `true`.
- `npm run lint` runs Oxlint, configured in `.oxlintrc.json`. The project has no ESLint.

## Environment variables and the runtime build

Vite writes env vars into the bundle when it builds. Nothing reads them while the app runs: `serve` only sends files,
and the code runs in the browser, where `process.env` does not exist.

- Only variables with the `VITE_` prefix reach the code, as `import.meta.env.VITE_*`. Everything in the bundle is
  public, so never give a secret a `VITE_` name.
- To use a variable of another component, import it under a `VITE_` name in `diploi.yaml`, eg
  `api.APP_ENDPOINT:VITE_API_URL`. Use a public `<HOST>_ENDPOINT`, because the browser cannot reach a
  `<HOST>_INTERNAL_ENDPOINT`.
- Staging and production build each commit on the deployment, with the deployment's env vars, once: a restart reuses
  the build, and a changed env var or a new commit builds again. If the build fails, the previous version keeps
  running and the deployment page shows the log, so run `npm run build` before calling a change done.
- The image holds no code and no Dockerfile is in the project. System packages go into `initScript` (every start, as
  root) or `preBuildScript` (only the build) of the component in `diploi.yaml`.

## Documentation

React and Vite publish their documentation for LLMs at <https://react.dev/llms.txt> and <https://vite.dev/llms.txt>.
Their pages are also available as Markdown, with `.md` added to the URL.
