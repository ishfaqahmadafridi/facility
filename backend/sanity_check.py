import requests
import time

BASE_URL = "http://127.0.0.1:8000"

def test_backend():
    print("--- Starting Backend Sanity Check ---")
    
    # 1. Check Health/Docs
    try:
        resp = requests.get(f"{BASE_URL}/docs")
        if resp.status_code == 200:
            print("[PASS] Swagger Docs available.")
        else:
            print(f"[FAIL] Docs returned {resp.status_code}")
    except Exception as e:
        print(f"[ERROR] Could not connect to backend: {e}")
        return

    # 2. Test OTP Request
    print("\nTesting OTP Request...")
    payload = {"email": "test@example.com"}
    resp = requests.post(f"{BASE_URL}/auth/request-otp", json=payload)
    if resp.status_code == 200:
        print("[PASS] OTP request successful.")
    else:
        print(f"[FAIL] OTP request failed: {resp.text}")

    # 3. Test Public Feed
    print("\nTesting Public Job Feed...")
    resp = requests.get(f"{BASE_URL}/feed/jobs")
    if resp.status_code == 200:
        print(f"[PASS] Job feed returned {len(resp.json())} jobs.")
    else:
        print(f"[FAIL] Job feed failed: {resp.text}")

    print("\n--- Sanity Check Complete ---")

if __name__ == "__main__":
    test_backend()
