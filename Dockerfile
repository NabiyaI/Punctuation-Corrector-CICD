FROM python:3.10-slim

WORKDIR /app

# Install dependencies required for the model and application
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create directory for model weights
RUN mkdir -p /app/model_weights

# Copy application source code
COPY app.py .

# Expose port for FastAPI
EXPOSE 8000

# Start Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
