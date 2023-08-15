# Use the official Node.js image as the base image
FROM node:18 as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React app
RUN npm run build

# Use a lightweight Nginx image for serving the production build
FROM nginx:alpine

# Copy the built app from the previous stage to the Nginx directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the Nginx port
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
