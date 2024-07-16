# Dummy Python API

This is a dummy Python REST API that has all HTTP methods available and randomly generates error.

The main propose of this application is to have some inputs for Prometheus, Vector and Loki.

There is no intention to run in a production environment, thats why we are not using a WSGI. If you do, I suggest to use gunicorn.

## Testing

This repository has a script `test-api.sh` that make many requests to the API.

## Enable Debug

Just set the variable `DEBUG_MODE` in front of the command:

```sh
DEBUG_MODE=whatevervalue make run
```

## Prometheus

The API expose its metrics in `/metrics`.

### Relevant metrics

- `request_latency_seconds_bucket`: count the number of requests answered less than the time specified by the bucket. Example: `request_latency_seconds_bucket{endpoint="/",le="0.25",method="OPTIONS"} 2.0`, it means that the application received 2 requests and their response were generated less than 0.25 second.

- `request_count_total`: count the number of requests in an endpoint. Example: `request_count_total{endpoint="/",http_status="404",method="POST"} 3.0`, it means that the application received 3 requests and answered with 404 for the endpoint "/". Its expects because the application is not serving "/".

- `request_latency_seconds_sum`: the sum of time waste by this endpoint and method. Example: `request_latency_seconds_sum{endpoint="/",method="DELETE"} 0.00010514259338378906`, it means that the DELETE method for the endpoint "/" is not an issue, as it was not requested too much. Considering the app is not serving "/", when running in production, the reverse proxy (like nginx) could block requests on "/", avoiding the requests to reach the application.
