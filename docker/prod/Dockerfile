FROM elixir:1.13.3-alpine

ENV APP_HOME=/app
ENV MIX_ENV=prod
ENV APP_SRC=polish_names/

WORKDIR $APP_HOME

COPY $APP_SRC $APP_HOME/

RUN apk add --update bash openssl postgresql-client

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile && \
    mix assets.deploy

RUN chmod u+x $APP_HOME/run.sh

EXPOSE 4000

CMD [ "bash", "./run.sh" ]