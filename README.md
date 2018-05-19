<img src="logo.png" alt="WaTF-Bank" width="200" align="center"> 

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

What-a-Terrible-Failure Mobile Banking Application (WaTF-Bank), which uses python (Flask framework) as a backend server, is built for Android and iOS App. The objective of this project:
- Application developers can understand and consider mobile application security aspect by investigating the vulnerable app (WaTF-Bank) on both Android and iOS platforms.
- Penetration testers can practice security assessment skill on mobile application in order to identify and understand the implication of the vulnerable app.

## List of Vulnerabilities

- Hardcoded Sensitive Information
- Unauthorized Code Modification
- Excessive App Permissions
- Unsupported version of OS Installation Allowed
- Unrestricted Backup File
- Application Debuggable
- Weak Cryptographic Algorithm
- Hardcoded key
- Custom Encryption Protocol
- Insecure Local Storage
- Unencrypted Database File
- Information Disclosure Through Logcat
- Sensitive Information Protection on Application Backgrounding
- Copy/Paste Buffer Caching
- Keyboard Input Caching
- Sensitive Information Masking
- Android Content provider flaw
- Android Broadcast receiver flaw
- Client-Side Based Authentication flaw
- Hidden and Extraneous Functionality
- Runtime Manipulation/Code Tampering
- Misuse of Biometric Authentication
- Insecure Communication Channel
- Weak Password Policy for Password/PIN
- Input Validation on API (SQL Injection, Negative value)
- Information Exposure through API Response Message
- Control of Interaction Frequency on API
- Account Enumeration
- Account Lockout Policy
- Session timeout and Session termination
- Authorization flaws

## Backend Server

Required Library
- flask  
- flask_sqlalchemy
- flask_script
- flask_migrate

Easy installation through

```
pip3 install -r requirements.txt
```

Starting backend (The database will also be remigrated)
```
./StartServer
```

## Author

- Boonpoj Thongakaraniroj
- Parameth Eimsongsak
- Prathan Phongthiproek
- Krit Saengkyongam

## License
This project is using the MIT License.

Copyright (c) 2018 WaTF-Team
