# Yavne'el pioneers landing page: GitHub Pages only

No external services. Files: `index.html` (the page), `details.json` (the 7 editable details), `CNAME`.

## Admin
- Open `/#admin` (there is no visible button). A login box appears. The admin email and password are hardcoded at the top of the script in `index.html`
  (`ADMIN_EMAIL`, `ADMIN_PASSWORD`). That login only unlocks the editing UI in the browser; it is NOT a security barrier,
  because the repo is public and the code is readable.
- What actually protects the site is GitHub: a change only goes live when it is committed to `details.json`.
  - With a GitHub token pasted in the bar: "שמירה" commits the change by itself (live in about a minute).
    Create a fine-grained token at GitHub -> Settings -> Developer settings, only for this repo, Contents: read and write.
  - Without a token: "שמירה" downloads `details.json`; upload it to the repo to publish it.
- Only the 7 fields in `details.json` can be edited from the page.

## Registration
There is no server, so the form opens a prefilled email (to both addresses) in the visitor's own mail app, and the
visitor has to press send. If they close it without sending, nothing reaches you.

## Empty details are hidden
Any of the 7 details with no value is not shown on the public page. Fill one in (admin mode shows all 7) and it appears automatically.
