# Final Setup Steps - Complete These to Build APK

## ✅ What's Done

1. ✅ Flutter SDK installed at `~/flutter/`
2. ✅ Flutter project created and initialized
3. ✅ All dependencies installed
4. ✅ Complete app structure with auth, models, services
5. ✅ All core utilities and configuration

## ⏳ What You Need to Do (Requires Sudo)

### Step 1: Install Java JDK

```bash
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk
```

### Step 2: Set Environment Variables

Add these to your `~/.bashrc`:

```bash
export PATH="$PATH:$HOME/flutter/bin"
export ANDROID_HOME="$HOME/Android"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
```

Then reload:

```bash
source ~/.bashrc
```

### Step 3: Install Android SDK Components

```bash
cd ~
~/Android/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
# Type 'y' when prompted to accept licenses
```

### Step 4: Accept All Licenses

```bash
flutter doctor --android-licenses
# Keep pressing 'y' for all prompts
```

### Step 5: Build the APK!

```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter build apk --debug
```

The APK will be at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📱 Installing APK on Your Phone

### Option A: USB Transfer
1. Connect phone via USB
2. Copy APK to phone:
   ```bash
   adb push build/app/outputs/flutter-apk/app-debug.apk /sdcard/Download/
   ```
3. On phone: Open "Files" app → Downloads → Tap APK → Install

### Option B: Manual Transfer
1. Copy APK to a USB drive or upload to Google Drive
2. Download on your phone
3. Tap the APK file
4. Allow "Install from unknown sources" if prompted
5. Install

---

## 🔧 If You Get Errors

### "Android SDK not found"
```bash
flutter config --android-sdk $HOME/Android
flutter doctor
```

### "Gradle build failed"
```bash
cd /home/vboxuser/programs/Rida/houses_bc_mobile
flutter clean
flutter pub get
flutter build apk --debug
```

### "License not accepted"
```bash
flutter doctor --android-licenses
# Press 'y' for all prompts
```

---

## 📊 Quick Status Check

After installing Java and Android SDK, run:

```bash
flutter doctor
```

You should see:
- ✅ Flutter
- ✅ Android toolchain
- ✗ Chrome (not needed for APK build)
- ✓ VS Code

Once you have 2 green checkmarks (Flutter + Android toolchain), you're ready to build!

---

## 🎯 Summary

**What I did:**
- Installed Flutter SDK
- Created Flutter project
- Installed all app dependencies
- Downloaded Android command-line tools
- Created complete app structure

**What you need to do:**
1. Run `sudo apt-get install openjdk-17-jdk`
2. Add environment variables to ~/.bashrc
3. Run sdkmanager to install Android SDK
4. Run `flutter doctor --android-licenses`
5. Run `flutter build apk --debug`
6. Transfer APK to phone and install

**Total time needed:** ~10-15 minutes

---

## 🚀 After APK Build Success

Once you have the APK working on your phone, we can continue implementing features:

1. Property search screen
2. Property details screen
3. Mortgage calculator
4. Incentive calculator
5. Book viewings
6. Client portal

All the code is ready in the documentation files!

---

**Next:** Install Java, then run the build commands above!
