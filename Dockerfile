FROM node:16-alpine3.11
WORKDIR /app
COPY index.js .
RUN npm install express
ENTRYPOINT ["node"]
CMD ["index.js"]
