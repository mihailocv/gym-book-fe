# =========================================
# Stage 1: Build the Angular Application
# =========================================
FROM dhi.io/node:24-alpine3.22-dev AS builder

WORKDIR /app

# Copy package files first for caching
COPY package.json pnpm-lock.yaml* ./

# Install dependencies using pnpm (already pre-installed in DHI node image)
RUN --mount=type=cache,target=/root/.pnpm-store pnpm install --frozen-lockfile

# Copy the rest of the application source code
COPY . .

# Build the Angular application
RUN pnpm run build

# =========================================
# Stage 2: Prepare Nginx to Serve Static Files
# =========================================
FROM dhi.io/nginx:1.28.0-alpine3.21-dev AS runner

# Copy custom Nginx server config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static build output from the build stage to Nginx's default HTML serving directory
COPY --chown=nginx:nginx --from=builder /app/dist/*/browser /usr/share/nginx/html

USER nginx
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=10s \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]