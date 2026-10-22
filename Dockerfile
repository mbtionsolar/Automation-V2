FROM python:3.12-slim

# LibreOffice (Writer only) + fonts for DOCX -> PDF
RUN apt-get update && apt-get install -y --no-install-recommends \
      libreoffice-writer fontconfig fonts-liberation \
      fonts-crosextra-caladea fonts-crosextra-carlito fonts-dejavu-core \
      fonts-noto-core fonts-roboto \
    && rm -rf /var/lib/apt/lists/*

COPY fonts.conf /etc/fonts/local.conf
RUN fc-cache -f

ENV WEB_MODE=1 PYTHONUNBUFFERED=1 HOME=/tmp
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD gunicorn app:app --bind 0.0.0.0:${PORT:-10000} --workers 1 --threads 2 --timeout 300
