# React + Vite

A client-side [React](https://react.dev/) app built with [Vite](https://vite.dev/), from the `react-ts` template of
`create-vite`.

## This component

- There is no server code and no SSR. Staging and production serve the static build in `dist/` with `serve -s`,
  which answers unknown paths with `index.html`, so client-side routing works. Anything that needs a server, a secret
  or a database belongs in another component.
- Serves on port **5173** in every stage: the Vite default in development, and `serve -l 5173` in `Dockerfile`.
- Development runs `npm run dev -- --host` (`Dockerfile.dev`). Staging and production run `npm run build`, which is
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
- Staging and production use a **runtime build** by default: each time the component starts, it runs
  `npm run build` again with the deployment's env vars and serves the result. A changed value only reaches the
  bundle when the component restarts. If that build fails, the new version of the component does not start, so run
  `npm run build` before calling a change done.
- With `__VITE_RUNTIME_BUILD` set to `false` in the component's `env.include` in `diploi.yaml`, the build made in the
  image is served instead. It has none of the deployment's env vars, only the static values from `diploi.yaml`, and
  `vite build` only sees those once they are declared with `ARG` in the `builder` stage of `Dockerfile`.

## Documentation

React and Vite publish their documentation for LLMs at <https://react.dev/llms.txt> and <https://vite.dev/llms.txt>.
Their pages are also available as Markdown, with `.md` added to the URL.
