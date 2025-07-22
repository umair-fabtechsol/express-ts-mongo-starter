FROM node:22 AS base


WORKDIR /usr/src/app

# Install pnpm
RUN npm install -g pnpm

# Copy package files and lockfile
COPY package.json pnpm-lock.yaml tsconfig.json ecosystem.config.json ./

# Copy source files
COPY ./src ./src

RUN ls -a

# Use --no-frozen-lockfile since we're building from scratch
RUN pnpm install && pnpm compile

# Production stage
FROM node:22-slim AS production

WORKDIR /usr/prod/app

ENV NODE_ENV=production
ENV PORT=8080

# Install pnpm
RUN npm install -g pnpm pm2


# Copy package files and lockfile
COPY package.json pnpm-lock.yaml ecosystem.config.json ./

# Use --no-frozen-lockfile and --prod for production dependencies only
RUN pnpm install 

COPY --from=base /usr/src/app/dist ./dist

# Expose the port the app runs on
EXPOSE 8080

# Start the Node.js app
CMD ["pnpm", "start"]