from flask import Flask, request, jsonify
import random
import time
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Define possible responses
responses = {
    "success": {"status": "success"},
    "error": {"status": "error", "message": "Something went wrong"}
}

# Define possible error HTTP status codes
error_codes = [400, 401, 403, 404, 500, 502, 503, 504]

# Prometheus metrics
REQUEST_COUNT = Counter('request_count', 'Total Request Count', [
                        'method', 'endpoint', 'http_status'])
REQUEST_LATENCY = Histogram(
    'request_latency_seconds', 'Request Latency', ['method', 'endpoint'])


def get_random_response():
    if random.choice([True, False]):
        time.sleep(random.uniform(0, 5))
        return jsonify(responses["success"]), 200
    else:
        return jsonify(responses["error"]), random.choice(error_codes)

def start_timer():
    request.start_time = time.time()


def stop_timer(response):
    resp_time = time.time() - request.start_time
    REQUEST_LATENCY.labels(request.method, request.path).observe(resp_time)
    return response


def record_request_data(response):
    REQUEST_COUNT.labels(request.method, request.path,
                         response.status_code).inc()
    return response


@app.route('/api/resource', methods=['GET'])
def get_resource():
    return get_random_response()


@app.route('/api/resource', methods=['POST'])
def create_resource():
    return get_random_response()


@app.route('/api/resource', methods=['PUT'])
def update_resource():
    return get_random_response()


@app.route('/api/resource', methods=['DELETE'])
def delete_resource():
    return get_random_response()


@app.route('/api/resource', methods=['PATCH'])
def patch_resource():
    data = request.json
    return get_random_response()


@app.route('/api/resource', methods=['OPTIONS'])
def options_resource():
    response, status_code = get_random_response()
    response.headers['Allow'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS'
    return response, status_code


@app.route('/metrics', methods=['GET'])
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}


if __name__ == '__main__':
    app.before_request(start_timer)
    app.after_request(record_request_data)
    app.after_request(stop_timer)

    app.run(debug=True, port=5000)
