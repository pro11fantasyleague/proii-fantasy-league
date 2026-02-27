# Production Secrets Rotation Guide

This guide outlines the steps to rotate sensitive secrets for the **ProII Fantasy League** production environment.

## When to Rotate?
*   Immediately if you suspect a breach.
*   Regularly (e.g., every 90 days) as a best practice.
*   When a team member with access leaves the project.

## Checklist

### 1. Supabase Secrets
1.  Go to **Supabase Dashboard** > **Project Settings** > **API**.
2.  Click **Rotate** next to `service_role` (secret) key.
    > **WARNING**: This will immediately break any backend services using the old key.
3.  Update your Edge Functions secrets:
    ```bash
    supabase secrets set SUPABASE_SERVICE_ROLE_KEY=new_key_here --env-file .env.prod
    ```
4.  Redeploy Edge Functions:
    ```bash
    supabase functions deploy process-draft
    supabase functions deploy simulate-live-stats
    ```

### 2. Flutter App (Client Keys)
*   **Anon Key**: While `anon` key is technically public, rotating it invalidates old client versions.
*   If you rotate the `anon` key in Supabase:
    1.  Update `.env.prod`.
    2.  Rebuild the Flutter app release bundle (`flutter build appbundle`).
    3.  Push an immediate update to App Store/Play Store.
    > **Impact**: Users on old versions will be unable to connect until they update.

### 3. External Services (Sentry)
1.  Go to **Sentry Settings** > **Client Keys (DSN)**.
2.  Revoke the old DSN.
3.  Generate a new DSN.
4.  Update `lib/main_prod.dart` with the new DSN.
5.  Rebuild and deploy the app.

### 4. CI/CD (GitHub Actions / Codemagic)
*   Update any environment secrets stored in your CI/CD provider settings (e.g., `SUPABASE_ACCESS_TOKEN`, `BETA_DISTRIBUTION_KEY`).

## Emergency Rollback
*   If rotation causes a critical failure, you cannot "un-rotate" a generated key. You must update the dependent services with the *new* key immediately.
