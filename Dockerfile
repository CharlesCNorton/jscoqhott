FROM node:18-bullseye-slim
WORKDIR /opt/jscoq
RUN npm init -y && npm install jscoq@0.17.1 bootstrap katex static-server
COPY index.html /opt/jscoq/index.html
EXPOSE 8080
CMD ["npx", "static-server", "/opt/jscoq", "-p", "8080"]
