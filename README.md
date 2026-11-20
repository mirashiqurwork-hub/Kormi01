# KORMI - Spinning Mill Workforce App

Spinning Mill workforce management - Android, iOS, Computer - এক কোডে সব চলবে।

## Design
Navy Blue #0A1D3F + Champagne Gold #C9A961 / #D4AF37 + Glassmorphism
Live Wallpaper Factory + Chimney Smoke - সব স্ক্রিনে একই ব্যাকগ্রাউন্ড।

## Features
- Workers - Card Number Unique, Company + Unit + Shift + Date
- Attendance - Date / Unit / Permanent Shift P/A, P/B, P/C - Present / Absent / Off
- Manpower - Back / Ring / A/Cone Fixed - শুধু Active + Present
- Production - Carding, Drawing, Simplex, Ring, Winding, Packing + Calculator
- Breakdown - Machine বন্ধ Entry + OCR
- Messages - 【entity-WhatsApp¦canonical_name=WhatsApp】 এর মতো, 1-1 + Group, Text, Voice, Photo, Video, File, Live Location, Audio / Video Call
- Location - Map + List, Unit / Section / Shift Filter
- Admin - Pending Approve, Company, Shift Rotation, Night Bill, Bottom Bar Edit
- ASK AI - Free Offline, No API Key, Bangla / English / Banglish
- OCR - Camera Icon Everywhere - Gallery Photo + Take Photo
- Overtime - Date / Unit / Shift + Night Bill Company অনুযায়ী

## Roles
- Admin / Management - সব দেখতে পারবে
- Officer - শুধু নিজের Unit + Permanent Shift
- Worker - শুধু নিজে

## Login
- Admin: ADMIN / ADMIN123
- Worker / Officer: নিজে Register - Pending - Admin Approve করলে ঢুকতে পারবে
- Logout না করা পর্যন্ত Login থাকবে, ডাটা ডিলিট হবে না

## Shift Rotation
শুক্রবার Rotation। Permanent Shift নাম একই থাকবে, শুধু Running Shift ঘুরবে।
Night -> B, B -> সকাল, সকাল -> Night

## Security
Password Hash, 5 বার ভুল দিলে 15 মিনিট Lock, Encrypted DB / Settings / Backup, Audit Log, Screenshot Block Sensitive স্ক্রিনে, Root Warning, App Lock Optional Default Off।

## No Keys In Public Repo
Firebase / Maps / Call Key Public Repo তে নাই। Repo Private করার পর Key বসবে। এখন Placeholder।

## Run
```bash
flutter pub get
flutter run
