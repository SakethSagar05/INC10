1) How is the local tip selected?
   The local tip is selected programmatically by looking up a fixed category constant (password_help) in an on-device map database (_tipDatabase). This ensures the logic is structured and deterministic without needing hardcoded string checks or network requests.
2) What is one privacy choice made in this implementation?
   All form data and tip lookups are processed entirely on-device with zero network requests or telemetry tracking. This protects user privacy by ensuring that sensitive inputs like passwords and emails never leave the local device.