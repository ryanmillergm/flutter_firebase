# Firebase Task Tutorial

A Flutter task management tutorial app that uses Firebase for authentication,
task storage, and image uploads. Users can sign up, sign in, view their tasks,
and create new tasks with a title, description, date, color, and image.

This is a learning project, not a production-ready app.

## Tech Stack

- Flutter and Dart
- Firebase Core
- Firebase Auth for email/password sign up and sign in
- Cloud Firestore for task documents
- Firebase Storage for task images
- Image Picker for selecting images from the device gallery
- Flex Color Picker for task color selection
- Dotted Border for the image upload area
- Intl for date formatting
- UUID for generating task and image ids

## App Flow

1. Launch the app.
2. Sign up with an email and password, or go to the sign-in page.
3. After authentication, the app shows the task list.
4. Tap the add button to create a task.
5. Select an image from the device gallery.
6. Enter a title and description.
7. Pick a date and color.
8. Submit the task.

The app uploads the selected image to Firebase Storage and saves task metadata
to Cloud Firestore for the signed-in user.

## Local Setup

Install Flutter and confirm your environment:

```powershell
flutter doctor
```

Install project dependencies:

```powershell
flutter pub get
```

Run static analysis:

```powershell
flutter analyze
```

Run the app:

```powershell
flutter run
```

To run on a specific Android emulator:

```powershell
flutter run -d emulator-5554
```

## Firebase Setup

This project is configured for Firebase project `fir-tutorial-7bbfc`.

Firebase client configuration is stored in:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `firebase.json`

These files contain public client configuration such as `apiKey`, `appId`,
`projectId`, and `storageBucket`. They are expected in a Flutter Firebase
client app and are not admin secrets.

Before running the app against your own Firebase project, make sure these
Firebase services are enabled:

- Authentication with the Email/Password provider
- Cloud Firestore
- Firebase Storage

If you need to connect the app to a different Firebase project, run:

```powershell
flutterfire configure --project=<your-firebase-project-id>
```

## Android Emulator Image Testing

The image picker reads from the Android emulator's media library, not from a
Flutter project folder.

To test image uploads:

1. Start the Android emulator.
2. Drag `.jpg` or `.png` files onto the emulator window, or place them in:

```text
/sdcard/Pictures/
/sdcard/DCIM/
/sdcard/Download/
```

3. Open the emulator's Photos app once to confirm the images appear.
4. If the picker is empty, use **Cold Boot Now** from Android Studio Device
   Manager and try again.

The app logs image picker results with `debugPrint`, including the selected
image path or picker errors.

## Firebase Rules

The tutorial may use permissive Firebase Storage rules while testing locally.
Do not use open test-mode rules in production.

Unsafe test rules look like this:

```js
allow read, write: if request.time < timestamp.date(2026, 6, 12);
```

For production, lock Storage and Firestore access to authenticated users and
scope data by user id. A safer Storage pattern is:

```js
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/images/{imageId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

The app upload path should match the Storage rules you choose.

## Secrets

Do not commit real secrets, including:

- `.env` files
- Firebase Admin SDK service account JSON files
- Google Cloud service account keys
- private signing keys or keystore passwords
- third-party API secrets
- CI/CD deployment tokens

Firebase client config files are not admin credentials. Project access should be
protected with Firebase Auth, Security Rules, App Check, IAM, and billing
alerts.

## Troubleshooting

If authentication fails:

- Confirm Email/Password sign-in is enabled in Firebase Console.
- Confirm `Firebase.initializeApp(...)` runs before Firebase Auth calls.

If task saves fail:

- Check Firestore rules.
- Confirm the user is signed in.
- Watch the Flutter console for Firebase exceptions.

If image upload fails:

- Confirm Firebase Storage is enabled.
- Check Storage rules.
- Confirm an image was selected before submitting.
- Cold boot the Android emulator if gallery images do not appear.

If dependencies or generated files are stale:

```powershell
flutter clean
flutter pub get
```
