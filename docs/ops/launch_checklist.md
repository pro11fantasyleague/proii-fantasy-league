# Launch Checklist

## Phase 1: Pre-Build Configuration
- [ ] **Generate Keystore**:
  ```bash
  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
- [ ] **Configure Signing**:
  - Create `android/key.properties`.
  - Update `android/app/build.gradle` to use `signingConfigs.release`.
- [ ] **Update Secrets**:
  - Replace placeholder Sentry DSN in `lib/main_prod.dart`.
  - Verify Supabase URL/Anon Key in `.env.prod`.
- [ ] **Update Version**:
### 1. Build & Sign (COMPLETE)
- [x] **Generate Keystore:** Created `android/upload-keystore.jks`.
- [x] **Configure Properties:** `android/key.properties` matches keystore.
- [x] **Build Bundle:** Generated `app-release.aab`.

### 2. Google Play Console Upload (TODO)
- [ ] **Create App:** "ProII Fantasy League"
- [ ] **Upload Bundle:** Upload `build\app\outputs\bundle\release\app-release.aab` to Production track.
- [ ] **Store Listing:** Copy title, short description, and full description from `docs/store/metadata.md`.
- [ ] **Screenshots:** Upload `docs/store/screenshots/` (if generated).
- [ ] **Privacy Policy:** Link to hosted Privacy Policy.

### 3. Verification (Post-Launch)
- [ ] **Internal Testing**:
  - [ ] Upload the `.aab` file to "Internal Testing" track.
  - [ ] Add testers (email list).
  - [ ] Verify installation on physical device.

## Phase 4: Launch
- [ ] **Promote to Production**: Move release from Internal/Closed Testing to Production.
- [ ] **Review**: Submit for review (takes 1-7 days).
- [ ] **Marketing**: Share Invite Codes on social channels.

## Phase 5: Monitoring
- [ ] **Sentry**: Watch for new issues in Sentry dashboard.
- [ ] **Supabase**: Monitor Database CPU and Realtime connections.
