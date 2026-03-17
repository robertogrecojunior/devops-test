import json
from datetime import datetime
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

# Prometheus metric
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "Tempo de resposta das requisições HTTP",
    ["method", "endpoint"]
)

def log_request(endpoint, status):
    log_entry = {
        "timestamp": datetime.utcnow().isoformat(),
        "level": "INFO",
        "method": request.method,
        "endpoint": endpoint,
        "status": status,
        "remote_addr": request.remote_addr
    }
    print(json.dumps(log_entry))

@app.before_request
def start_timer():
    request.start_time = time.time()

@app.after_request
def record_latency(response):
    latency = time.time() - request.start_time
    REQUEST_LATENCY.labels(
    method=request.method,
    endpoint=request.path
).observe(latency)
return response

@app.route("/")
def home():
    REQUEST_COUNT.labels(method="GET", endpoint="/").inc()
    log_request("/", 200)
    return jsonify({"message": "DevOps Test Running"})

@app.route("/health")
def health():
    REQUEST_COUNT.labels(method="GET", endpoint="/health").inc()
    log_request("/health", 200)
    return jsonify({"status": "alive"})

@app.route("/ready")
def ready():
    REQUEST_COUNT.labels(method="GET", endpoint="/ready").inc()
    log_request("/ready", 200)
    return jsonify({"status": "ready"})

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
