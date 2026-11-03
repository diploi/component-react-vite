# syntax=docker/dockerfile:1
# The base has the toolchain, diploi-pm and the entrypoint that runs the project's initScript (diploi/component-bases).
# The code is not in the image: staging and production build the deployment's commit on its own machine, development
# runs the working copy
FROM public.ecr.aws/p8t2q7f4/diploi/component-bases/node26:v1

# Serves the build in staging and production
RUN npm i -g serve

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
