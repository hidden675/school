# School Wax — Static Dashboard

This is a small static site containing student/teacher dashboards and login pages.

What I added for deployment:

- `.github/workflows/gh-pages.yml`: a GitHub Actions workflow that publishes the repository root to the `gh-pages` branch using `peaceiris/actions-gh-pages`. This will publish the static site to GitHub Pages automatically after you push to `main`.
- `.gitignore`: common ignores for editors and node artifacts.

How to publish (PowerShell):

1. Create a GitHub repository on GitHub (note the repo name). 2. In this project folder run:

```powershell
git remote add origin https://github.com/<your-username>/<your-repo>.git
git branch -M main
git push -u origin main
```

The GitHub Actions workflow will run on push to `main` and publish the site. Your Pages URL will be:

https://<your-username>.github.io/<your-repo>/

If you want me to push for you, provide the repository URL (or a personal access token) and say so — otherwise run the commands above locally.
