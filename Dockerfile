# =========================================
# Stage 1: Build the Angular Application
# =========================================
FROM dhi.io/node:24-alpine3.22-dev AS builder

WORKDIR /app

# Copy package files first for caching
COPY package.json pnpm-lock.yaml ./

# Install dependencies using pnpm (pre-installed in DHI node image)
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm config set store-dir /pnpm/store && \
    pnpm install --frozen-lockfile

# Copy the rest of the application source code
COPY . .

# Build the Angular application
RUN pnpm run build

# =========================================
# Stage 2: Prepare Nginx to Serve Static Files
# =========================================
FROM dhi.io/nginx:1.28.0-alpine3.21-dev AS runner

# Copy Nginx config + shared security headers
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY security-headers.inc /etc/nginx/conf.d/security-headers.inc

# Copy the static build output
COPY --chown=nginx:nginx --from=builder /app/dist/gym-book-fe/browser /usr/share/nginx/html

USER nginx
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]