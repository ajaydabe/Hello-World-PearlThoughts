# Stage 1: Build the application
FROM node:lts-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
# Assuming you have a build script in package.json
RUN npm run build

# Stage 2: Create the final image
FROM node:lts-alpine-slim

WORKDIR /app

# Copy only the build artifacts
COPY --from=builder /app/build .

CMD [ "node", "index.js" ]