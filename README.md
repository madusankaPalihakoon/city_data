# city_data

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

From your logs, it looks like your Flutter NTRIP client is successfully connecting to the NTRIP caster but is not receiving the expected **RTCM correction data**.

### **What the Logs Indicate:**

1. **Successful Connection to Mountpoint (`VRS`)**

   - `Connected to mountpoint: VRS`
   - This means your client is connecting to the NTRIP caster and the specific mountpoint.

2. **NTRIP Server Response (`ICY 200 OK`)**

   - `ICY 200 OK` is the standard response from an NTRIP caster when the connection is successful.
   - Other headers:
     - `Server: PowerNetwork/3.1` → The NTRIP server software version.
     - `Date: Fri, 5 2 2025 21:52:3 Standard time` → The server time.

3. **Unexpected Data: `ET1020-VOK!`**
   - This is **not** standard RTCM correction data.
   - Possible causes:
     - The mountpoint may not be actively broadcasting RTCM data.
     - The NTRIP server may require an **NMEA GGA sentence** from your client to send corrections.
     - The server might be sending a proprietary format instead of RTCM.

---

### **What You Should Do Next**

#### ✅ **1. Verify Mountpoint Configuration**

- Ensure that the mountpoint (`VRS`) is **actively broadcasting RTCM data**.
- Check if the mountpoint requires specific GNSS system support (GPS, GLONASS, etc.).
- Try a different mountpoint if available.

#### ✅ **2. Send an NMEA GGA Sentence**

- Many NTRIP servers require your **current location** before sending RTCM corrections.
- You need to send a properly formatted **NMEA GGA** sentence right after connecting.

Example NMEA GGA format:

```
$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47
```

- In Flutter, send this after connecting:
  ```dart
  String ggaSentence = "\$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47\r\n";
  socket.write(ggaSentence);
  ```

#### ✅ **3. Check for RTCM Data**

- If the server is broadcasting corrections, you should receive **binary RTCM** messages.
- The data should look like random **binary characters**, not readable text.

#### ✅ **4. Use an NTRIP Client to Test**

- Try connecting using an existing NTRIP client (like **RTKLIB STRSVR** or **SNIP**) to verify if RTCM data is being received.

---

### **Next Steps for Your Flutter Client**

Would you like help modifying your Flutter code to send an **NMEA GGA sentence** and correctly parse RTCM data? 🚀
