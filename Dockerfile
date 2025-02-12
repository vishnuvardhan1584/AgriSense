# Stage 1: Build
FROM node:16-slim AS builder
WORKDIR /app

# Copy package.json and package-lock.json (if present) for npm install
COPY package*.json ./

# Install all dependencies (including dev dependencies for the build)
RUN npm install

# Copy the rest of the application files
COPY . .

# Run the build script
RUN npm run build

# Stage 2: Production
FROM node:16-slim AS final
WORKDIR /app

# Copy the built files from the builder stage
COPY --from=builder /app/build ./build

# Copy only the production package.json and package-lock.json (optional)
COPY package*.json ./

# Install production dependencies only
RUN npm install --production

# Expose the port the app will run on
EXPOSE 3000

# Start the application (ensure that the start script exists in package.json)
CMD ["npm", "start"]
