# YatriFood Android MVP

A Flutter starter MVP for a train-seat food ordering concept.

## Included
- Hindi-first customer home screen
- Manual train, station, coach and seat entry
- Sample restaurant listings and menus
- Add/remove cart items and subtotal
- Demo order confirmation with generated order ID

## Not included yet
- Live PNR/train running status
- Real restaurant onboarding or order dispatch
- Payments, refunds, notifications or delivery-partner tracking
- Production database, admin panel or railway integrations

The sample restaurants and prices are fictional demo data. Do not present them as verified restaurants or live availability.

## Run on Android
1. Install Flutter SDK and Android Studio.
2. Extract this ZIP.
3. In the project folder run:
   ```bash
   flutter pub get
   flutter run
   ```
4. To build an APK:
   ```bash
   flutter build apk --release
   ```
   APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Suggested next development steps
1. Add Firebase Authentication and Firestore.
2. Create restaurant/admin dashboard and order status workflow.
3. Integrate a verified train schedule/PNR provider under a valid agreement.
4. Add payment gateway after business/KYC onboarding.
5. Pilot at one station with onboarded FSSAI-compliant restaurants and an agreed handoff process.

## Important
This is a runnable UI/demo flow, not a production-ready food delivery service. Confirm local station access, food safety, licensing, payment, privacy and railway requirements before taking real orders.

## Cloud APK build (GitHub Actions)
This repository includes `.github/workflows/android-apk.yml`.
After pushing the project to the `main` branch on GitHub:
1. Open the repository's **Actions** tab.
2. Select **Build YatriFood Android APK**.
3. Tap **Run workflow** if it has not started automatically.
4. When complete, open the run and download the `YatriFood-Android-APK` artifact.
GitHub may require Actions to be enabled for the repository.
