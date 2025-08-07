# Firebase Flutter Demo

A simple Flutter application that demonstrates how to use Firebase Cloud Firestore to build a real-time, cloud-synced counter.

## Features

- Real-time counter updates using Cloud Firestore.
- Cross-platform (works on Android and iOS).
- Basic setup for a new Firebase project.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Google account to create a Firebase project.

### 1. Set Up a Firebase Project

1.  Go to the [Firebase console](https://console.firebase.google.com/).
2.  Click on **"Add project"** and follow the on-screen instructions to create a new project.
3.  Once your project is created, you will be redirected to the project's dashboard.

### 2. Configure the Flutter App

You need to connect your Flutter app to the Firebase project.

#### For Android

1.  In your Firebase project dashboard, click on the Android icon to add an Android app.
2.  For the **"Android package name"**, enter `com.example.firebase_demo`. You can find this in `android/app/build.gradle.kts` (look for `applicationId`).
3.  You can skip the "App nickname" and "Debug signing certificate SHA-1" for now.
4.  Click on **"Register app"**.
5.  Download the `google-services.json` file.
6.  Place the downloaded `google-services.json` file in the `android/app/` directory of your Flutter project.
7.  **Configure Gradle Files**: To allow your Android app to use the `google-services.json` file, you need to add the Firebase Gradle plugin.
    -   In `android/build.gradle.kts`, add the `google-services` plugin to the `plugins` block:
        ```kotlin
        plugins {
            id("com.google.gms.google-services") version "4.4.2" apply false
        }
        ```
    -   In `android/app/build.gradle.kts`, apply the plugin by adding it to the `plugins` block:
        ```kotlin
        plugins {
            id("com.android.application")
            id("kotlin-android")
            id("com.google.gms.google-services") // Add this line
            // ...
        }
        ```

#### For iOS

1.  In your Firebase project dashboard, click on the iOS icon to add an iOS app.
2.  For the **"iOS bundle ID"**, enter `com.example.firebaseDemo`. You can find this in Xcode under `Runner > General > Identity > Bundle Identifier`.
3.  You can skip the "App nickname" and "App Store ID" for now.
4.  Click on **"Register app"**.
5.  Download the `GoogleService-Info.plist` file.
6.  Open the `ios` directory of your project in Xcode.
7.  Drag and drop the downloaded `GoogleService-Info.plist` file into the `Runner` directory within Xcode. When prompted, make sure to select **"Copy items if needed"** and add it to all targets.

### 3. Set up Firestore

1.  In your Firebase project dashboard, go to the **"Firestore Database"** section from the left-hand menu.
2.  Click on **"Create database"**.
3.  Choose **"Start in test mode"** for this demo. This will allow open access to your database. For a production app, you should set up proper security rules.
4.  Choose a location for your Firestore data.
5.  Click **"Enable"**.

### 4. Run the Application

1.  Open your terminal and navigate to the root directory of the project.
2.  Install the required packages by running:
    ```sh
    flutter pub get
    ```
3.  Run the app on your connected device or emulator:
    ```sh
    flutter run
    ```

Now, when you press the '+' button, the counter will update in real-time in the app and in your Firestore database. You can open multiple instances of the app (e.g., on two different emulators) to see the counter sync between them.
