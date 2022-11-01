FROM hackmdio/buildpack:node-10-95fb3df8 as BUILD

COPY --chown=hackmd:hackmd . .

RUN set -xe && \
    git reset --hard && \
    git clean -fx && \
    npm install && \
    npm run build && \
    cp ./deployments/docker-entrypoint.sh ./ && \
    cp .sequelizerc.example .sequelizerc && \
    rm -rf .git .gitignore .travis.yml .dockerignore .editorconfig .babelrc .mailmap .sequelizerc.example \
        test docs contribute \
        package-lock.json webpack.prod.js webpack.htmlexport.js webpack.dev.js webpack.common.js \
        config.json.example README.md CONTRIBUTING.md AUTHORS node_modules

FROM hackmdio/runtime:node-10-cjk-95fb3df8
USER hackmd
WORKDIR /home/hackmd/app
COPY --chown=1500:1500 --from=BUILD /home/hackmd/app .

RUN npm install --production && npm cache clean --force && rm -rf /tmp/{core-js-banners,phantomjs}

COPY --from=us-docker.pkg.dev/berglas/berglas/berglas:0.6.2 /bin/berglas /bin/berglas
RUN chmod +x /bin/berglas

EXPOSE 3000
ENTRYPOINT ["/home/hackmd/app/docker-entrypoint.sh"]
