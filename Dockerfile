# Stage 1: Build frontend
FROM node:18.9.1 AS frontend-builder

WORKDIR /frontend

COPY frontend/package*.json .
RUN npm install
COPY frontend/ .
RUN npm run build

# Stage 2: Build backend with frontend
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ .

# Copy built frontend to backend static directory
RUN mkdir -p static
COPY --from=frontend-builder /frontend/build static

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
