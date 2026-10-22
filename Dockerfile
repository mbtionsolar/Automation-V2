FROM python:3.12-slim

# LibreOffice (Writer only) + fonts for DOCX -> PDF
RUN apt-get update && apt-get install -y --no-install-recommends \
      libreoffice-writer fonts-liberation fonts-dejavu-core fonts-noto-core \
    && rm -rf /var/lib/apt/lists/*

ENV WEB_MODE=1 PYTHONUNBUFFERED=1 HOME=/tmp
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD gunicorn app:app --bind 0.0.0.0:${PORT:-10000} --workers 1 --threads 2 --timeout 300
