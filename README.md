# codex

This repository contains a sample iOS application to manage a smart plant pot.
The project `SmartPlantPotApp` demonstrates a simple SwiftUI interface that
allows:

- Login with Google using the GoogleSignIn SDK.
- Listing and adding plants with optional photo-based identification (stubbed).
- Managing locations for plants (rooms, office, etc.).
- Viewing plant details with current sensor values compared to ideal ranges.

The app includes placeholder areas where integration with the ChatGPT API and
sensor devices should be implemented.

## Google Sign-In setup

The sample uses the [GoogleSignIn](https://developers.google.com/identity/sign-in/ios) SDK. Add your OAuth client ID to `Info.plist` under the key `GOOGLE_CLIENT_ID` and configure URL schemes according to Google's documentation. Without these steps the Google login button will not authenticate users.
