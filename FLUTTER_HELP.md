# Flutter Environment Troubleshooting Guide

## Problem: 'flutter' is not recognized
This occurs because the Flutter SDK is either not installed or its `bin` folder is not in your system's PATH variable.

### 🛠️ How to Fix (Windows)

1.  **Download Flutter SDK**: If you haven't, download it from [docs.flutter.dev/get-started](https://docs.flutter.dev/get-started/install/windows/desktop?tab=download).
2.  **Extract**: Extract the zip file (e.g., to `C:\src\flutter`).
3.  **Update PATH**:
    -   In the Start search bar, type 'env' and select **Edit the system environment variables**.
    -   Click **Environment Variables**.
    -   Under **User variables**, find the entry named `Path`.
    -   Click **Edit** > **New**.
    -   Paste the full path to your flutter `bin` folder (e.g., `C:\src\flutter\bin`).
    -   Click **OK** on all windows.
4.  **Restart Terminal**: Close and reopen your terminal/PowerShell.
5.  **Verify**: Run `flutter --version`.

---

## 🚀 Instant Verification Workaround
If you want to see the app working **NOW** without waiting for the Flutter setup:
I can generate a **React-based Web Dashboard** in minutes. Since your machine already has `node` and `npm` (verified), this will run instantly.

**Run this to start the backend (Verified):**
```bash
cd backend
.\venv\Scripts\activate
uvicorn app.main:app --reload
```
