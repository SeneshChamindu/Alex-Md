# Use official Node.js runtime as a parent image
FROM node:20-alpine

# Set the working directory
WORKDIR /usr/src/app

# Install build essentials, ffmpeg, and curl
RUN apk add --no-cache python3 make g++ git ffmpeg curl

# Download and install latest official yt-dlp binary
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp

# Copy root package files
COPY package*.json ./

# Install root dependencies bypassing peer conflicts
RUN npm install --legacy-peer-deps --ignore-scripts

# Copy frontend package files
COPY Frontend/package*.json ./Frontend/

# Install frontend dependencies
RUN cd frontend && npm install --legacy-peer-deps

# Copy the rest of the application files
COPY . .

# Build the frontend assets for production
RUN cd Frontend && npm run build

# Expose the port (Railway uses PORT env variable, defaulting to 8000)
EXPOSE 8000

# Start the application
CMD ["node", "index.js"]
