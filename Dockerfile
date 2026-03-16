FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://localhost:8080/health || exit 1

CMD ["python", "app.py"]
