# iOS Authentication App
This iOS app provides a seamless authentication experience with options to create a user account and sign in using Email/Password, Google, and Apple.

## Features
- Create a new user with email and password
- Sign in with email and password
- Sign in with Google
- Sign in with Apple
- User-friendly interface
- Secure authentication using Firebase

## Requirements
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+
- CocoaPods

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Abhishek6353/WhatsApp-Chat.git
```

```bash
cd WhatsApp-Chat
```

### 2. Install Dependencies
Ensure you have CocoaPods installed. If not, you can install it using the following command:

```bash
sudo gem install cocoapods
```

Navigate to the project directory and run:

```bash
pod install
```


### 3. Firebase Setup
1. Go to the Firebase Console.
2. Create a new project or use an existing one.
3. Add an iOS app to your Firebase project.
4. Download the `GoogleService-Info.plist` file.
5. Add the `GoogleService-Info.plist` file to your Xcode project.


### 4. Google Sign-In Setup
1. Enable Google Sign-In in the Firebase Console under the "Authentication" section.
2. Configure the URL schemes in your Xcode project:
   - Open your project configuration: double-click the project name in the project navigator.
   - Select your app from the TARGETS section, then select the "Info" tab, and expand the "URL Types" section.
   - Click the "+" button, and add a URL scheme for your reversed client ID. This should be the REVERSED_CLIENT_ID   value from the `GoogleService-Info.plist`.


### 5. Apple Sign-In Setup
1. Enable Apple Sign-In in the Firebase Console under the "Authentication" section.
2. Configure the Apple Sign-In capability in Xcode:
  - Select your project and your target.
  - Go to the "Signing & Capabilities" tab.
  - Click the "+" button to add a capability and choose "Sign In with Apple".



## Usage
1. Open the .xcworkspace file in Xcode.
2. Build and run the app on a simulator or device.
3. Use the app to create a new user or sign in with email/password, Google, or Apple.


## Contact
For any questions or suggestions, please open an issue or contact me at itsabhi814@gmail.com.





