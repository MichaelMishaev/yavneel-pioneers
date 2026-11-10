# Landing page setup (GitHub Pages)

Static site: `index.html` only. GitHub Pages cannot run a server or keep secrets,
so two free services do the backend work:

| Need | Service | Setup |
|---|---|---|
| Email on every registration | FormSubmit (no account) | Step 1 |
| Admin login + editable details + registration backup | Supabase (free) | Steps 2-4 |

## 1. Email (works as soon as the page is live)
The first registration sends **an activation email** to the primary address. Open it and click the
confirm link. After that every registration is emailed to the primary address, with a copy to the second one.
Submit one test registration yourself right after publishing, then activate.

Heads-up: both addresses are visible in the page source (they are in the script). That is normal for
static sites, but it means they can be scraped. FormSubmit can give you a hidden random alias after
activation; ask me to switch the code to it.

## 2. Supabase project
1. Create a project at supabase.com.
2. SQL Editor → paste and run `supabase.sql`. It creates the 7 editable fields and the security rules.
3. Authentication → Sign In / Providers → **disable "Allow new users to sign up"**.
4. Authentication → Users → **Add user** → email `zarina1990@gmail.com`, a password you choose,
   tick "Auto Confirm User".
5. Project Settings → API → copy the **Project URL** and the **anon public** key into
   `SUPABASE_URL` and `SUPABASE_ANON_KEY` at the top of the `<script type="module">` in `index.html`.

## 3. Publish
Push the `site` folder contents to a GitHub repo → Settings → Pages → deploy from the branch root.

## 4. Use
"כניסת מנהל" (top of the page) → log in → the 7 detail fields become editable → "שמירה".
Registrations are also stored in the Supabase table `registrations` (Table Editor, admin only).

## Security notes
- The admin password is never in the code. Supabase checks it. The rules in `supabase.sql` let only the
  admin's email write, and only to the 7 allowed keys.
- Pick a strong password. A short one like `admin1` can be guessed, and this page is public.
- The anon key in `index.html` is meant to be public.
