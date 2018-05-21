<img src="logo.png" alt="WaTF-Bank" width="200" align="center"> 

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

What-a-Terrible-Failure Mobile Banking Application (WaTF-Bank), written in Java, Objective-C and Python (Flask framework) as a backend server, is designed to simulate a "real-world" web services-enabled mobile banking application that contains over 30 vulnerabilities. 

The objective of this project:
- Application developers, programmers and architects can understand and consider how to create secure software by investigating the vulnerable app (WaTF-Bank) on both Android and iOS platforms.
- Penetration testers can practice security assessment skill in order to identify and understand the implication of the vulnerable app.

## List of Vulnerabilities

| OWASP Mobile Top 10 2016 | Vulnerability Name |
| :------------ |:-------------|
| M1. Improper Platform Usage | <ul><li>Excessive App Permissions</li><li>Unsupported version of OS Installation Allowed</li><li>Unrestricted Backup File</li><li>Android Content provider Flaw</li><li>Android Broadcast receiver Flaw</li><li>Input Validation on API (SQL Injection, Negative value)</li><li>Information Exposure through API Response Message</li><li>Control of Interaction Frequency on API</li></ul> | 
| M2. Insecure Data Storage   | <ul><li>Insecure Application Local Storage</li><li>Insecure Keychain Usage</li><li>Unencrypted Database File</li><li>Sensitive Information on Application Backgrounding</li><li>Information Disclosure Through Device Logs</li><li>Copy/Paste Buffer Caching</li><li>Keyboard Input Caching</li><li>Lack of Sensitive Information Masking</li></ul> | 
| M3. Insecure Communication  | <ul><li>Insecure SSL Verification</li></ul> | 
| M4. Insecure Authentication | <ul><li>Client-Side Based Authentication Flaw</li><li>Account Enumeration</li><li>Account Lockout Policy</li><li>Weak Password Policy for Password/PIN</li><li>Misuse of Biometric Authentication</li><li>Session Management Flaw</li></ul> | 
| M5. Insufficient Cryptography | <ul><li>Hardcoded Encryption Key</li><li>Weak Cryptographic Algorithm</li><li>Custom Encryption Protocol</li></ul> | 
| M6. Insecure Authorization  | <ul><li>Insecure Direct Object Reference</li><li>Business Logic Flaw</li></ul> | 
| M7 Client Code Quality      | <ul><li>SQL Injection on Content provider</li><li>Insecure URL Scheme Handler</li></ul> | 
| M8. Code Tampering | <ul><li>Unauthorized Code Modification (Application Patching)</li><li>Weak Root/Jailbreak Detection</li><li>Method Swizzling</li></ul> | 
| M9. Reverse Engineering | <ul><li>Lack of Code Obfuscation</li></ul> | 
| M10. Extraneous Functionality | <ul><li>Application Debuggable</li><li>Hidden Endpoint Exposure</li></ul> | 

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

## Project Team

- Boonpoj Thongakaraniroj
- Parameth Eimsongsak
- Prathan Phongthiproek
- Krit Saengkyongam

## License
This project is using the MIT License.

Copyright (c) 2018 WaTF-Team
