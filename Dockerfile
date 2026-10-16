# Stage 1: Build React app
FROM node:20-alpine AS build

WORKDIR /app

ARG VITE_MAX_REPOS=50
ENV VITE_MAX_REPOS=$VITE_MAX_REPOS

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the React application
RUN npm run build


# Stage 2: Serve React app with Nginx
FROM nginx:alpine

# Remove default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy the React build output
COPY --from=build /app/dist /usr/share/nginx/html

# Configure SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]