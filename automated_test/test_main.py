import requests

#Variable
BASE_URL = "http://localhost:8000"

def test_status_returns_200():
     resp = requests.get(f"{API_BASE_URL}/status", timeout=5)
     assert resp.status_code == 200


def test_status_contains_cpu_and_memory_usage_keys():
    resp = requests.get(f"{API_BASE_URL}/status", timeout=5)
    data = resp.json()

# check top key
    assert "cpu" in data
    assert "memory" in data

# check keys
    assert "usage_percent" in data["cpu"]
    assert "total" in data["memory"]
    assert "available" in data["memory"]
    assert "used" in data["memory"]
    assert "usage_percent" in data["memory"]
