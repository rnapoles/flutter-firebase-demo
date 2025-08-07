# Firebase Flutter Demo

A Flutter application that demonstrates how to use Firebase Cloud Firestore to build a real-time, cloud-synced app. This project manages a simple counter and a more complex Book and Author database with a many-to-many relationship.

## Features

- Real-time counter updates using Cloud Firestore.
- Full CRUD (Create, Read, Update, Delete) for Books and Authors.
- Clean, card-based UI with a Navigation Drawer.
- Many-to-many relationship management between Books and Authors.

---

## Project Setup

To get this project running, you first need to connect it to your own Firebase project. We will use the official **FlutterFire CLI** for this, as it's the recommended and simplest method.

### 1. Install Required Tools

If you haven't already, you need to install two command-line tools: the Firebase CLI and the FlutterFire CLI.

- **Firebase CLI**:
  ```sh
  npm install -g firebase-tools
  ```
  After installing, log in to your Google account by running:
  ```sh
  firebase login
  ```

- **FlutterFire CLI**:
  ```sh
  dart pub global activate flutterfire_cli
  ```

### 2. Configure Firebase

Now, you can connect this Flutter project to your Firebase project.

- **Run the `configure` command** from the root directory of this project:
  ```sh
  flutterfire configure
  ```

- **Follow the prompts**: The CLI will guide you through the process:
  1.  It will ask you to select a Firebase project from your account. You can create a new one from the CLI if needed.
  2.  It will ask which platforms to configure for. Make sure to select **Android** and **iOS**.
  3.  The CLI will automatically generate the `firebase_options.dart` file in your `lib/` directory and perform the necessary native configurations.

### 3. Set up Firestore Database

You need to enable Firestore in your Firebase project.

1.  Go to your [Firebase project console](https://console.firebase.google.com/).
2.  In the left-hand menu, go to **Build > Firestore Database**.
3.  Click **Create database**.
4.  Choose **Start in test mode**. This allows open access for 30 days, which is fine for development.
    > **Note**: For a production app, you must write more secure rules!
5.  Choose a location for your Firestore data and click **Enable**.

### 4. Run the Application

1.  Ensure you have all the Flutter packages:
    ```sh
    flutter pub get
    ```
2.  Run the app on your desired device or emulator:
    ```sh
    flutter run
    ```

---

## Troubleshooting

### Android: `SecurityException` or Firebase/Google Sign-In Failures

If you run into authentication errors on Android, it's almost always because you need to add your computer's **SHA-1 debug fingerprint** to your Firebase project. The `flutterfire configure` command does not do this for you.

1.  **Generate the SHA-1 Fingerprint** by running the following command from the `android` directory of this project:
    -   On macOS/Linux: `./gradlew signingReport`
    -   On Windows: `gradlew.bat signingReport`

2.  **Copy the SHA-1 Key** from the output (look for the `debug` variant).

3.  **Add the Fingerprint to Firebase**:
    -   Go to your **Firebase project console > Project Settings > General**.
    -   Scroll down to your Android app and click **"Add fingerprint"**.
    -   Paste the SHA-1 key and save.

4.  **Re-run `flutterfire configure`**:
    After adding the fingerprint, it's a good practice to run `flutterfire configure` again to ensure all your local configuration files are up to date.

5.  **Rebuild your app**: Completely stop and rebuild your app. A hot reload is not enough.

### General: `MissingPluginException` after adding a new package

If you see a `MissingPluginException` in your error logs after adding a new Firebase package (or any other package with native code), it means your app needs to be fully rebuilt.

A simple hot reload or hot restart is not enough to link the new native code required by the plugin.

**Solution**:
1.  Completely **stop** the app from running in your IDE or terminal.
2.  Run `flutter clean` to clear out old build artifacts.
    ```sh
    flutter clean
    ```
3.  Run the app again with a fresh build.
    ```sh
    flutter run
    ```
