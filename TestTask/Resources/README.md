# 📝 TestTask – User Sign-Up App

A SwiftUI application demonstrating user registration form handling, field validation, sending POST requests via `multipart/form-data`, and response processing.

---

## 🔧 1. Configuration and Customization

### 📍 API Endpoint

The base API URL is located in `APIServiceImpl`. To change it:

```swift
let baseURL = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/")
```

### 📍 Validation

Validation rules are defined in `ValidationService.swift`. You can modify or add your own:

* Minimum name length
* Email format according to RFC2822
* Phone number validation to match `+380XXXXXXXXX` format
* Photo check (max 5MB, JPEG format)

### 📍 Styles

Colors and fonts can be customized via:

* `Assets.xcassets`
* `Info.plist`

---

## 📦 2. Dependencies

This project does not use third-party packages (CocoaPods or Swift Package Manager). All functionality is implemented natively using SwiftUI and Combine.

---

## 💠 3. Common Issues and Solutions

No issues were discovered during testing.

---

## 🧱 4. Build Instructions

### Requirements

* macOS 13+
* Xcode 15+
* Swift 5.9+

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/ChernovKonstantin/TestSignUpApp.git
   ```

2. Open the project:

   ```bash
   open TestTask-SignUpApp.xcodeproj
   ```

3. Build (Cmd + B) or run (Cmd + R) in the simulator or on a physical device.

### API Token

The token is requested automatically via `/api/v1/token` before each POST request, no manual setup needed.

---

## 📬 Contact

For feedback, bugs, or suggestions — open an issue or create a pull request in the repository.

---
