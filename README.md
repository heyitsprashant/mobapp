# mobapp

Repository: https://github.com/heyitsprashant/mobapp

This workspace has been initialized to push code to the above GitHub repository.

Notes:
- If the initial push fails due to authentication, configure GitHub authentication (PAT or SSH) and re-run the push command shown below.
- Update `git` local user.name and user.email to your real name and email if you don't want the placeholder values.

How to push manually (if needed):

1. Configure auth (recommended):
   - SSH: add your public key to GitHub and use the SSH remote.
   - HTTPS: create a Personal Access Token and use it when prompted.

2. Push:
   git add -A
   git commit -m "chore: initial commit"
   git branch -M main
   git remote add origin https://github.com/heyitsprashant/mobapp
   git push -u origin main
