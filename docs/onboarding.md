# Overleaf + GitHub Sync: Onboarding Guide

Step-by-step guide to connecting your Overleaf project with GitHub so you can
use Claude Code (with Lord of the Strings) on your LaTeX files.

---

## Prerequisites

- An Overleaf account with **Premium** features (most university accounts include this)
- A GitHub account
- Claude Code installed locally with the Lord of the Strings plugin

---

## Step 1: Link GitHub to Overleaf

1. Go to [Overleaf Account Settings](https://www.overleaf.com/user/settings)
2. Scroll to "GitHub Integration"
3. Click **Link** and authorize Overleaf to access your GitHub account

## Step 2: Create a GitHub Repo from Your Overleaf Project

1. Open your project in Overleaf
2. Click **Menu** (top-left hamburger icon)
3. Scroll down to **Sync** -> **GitHub**
4. Click **"Create a GitHub Repository"**
5. Choose a repo name and visibility (private recommended)
6. Overleaf pushes the current project state to the new repo

## Step 3: Clone Locally

```bash
git clone https://github.com/your-user/your-project.git
cd your-project
```

## Step 4: Open Claude Code

Launch Claude Code in the cloned directory. The Lord of the Strings plugin
will auto-detect `.tex` files and activate the session hooks.

## Step 5: Edit, Commit, Push

```bash
# After making changes with Claude Code:
git add -A
git commit -m "edits from Claude Code session"
git push
```

## Step 6: Pull into Overleaf

1. Open your project in Overleaf
2. Click **Menu** -> **GitHub** -> **"Pull GitHub changes into Overleaf"**
3. Your edits now appear in Overleaf

To go the other direction (Overleaf -> local), push from Overleaf first,
then `git pull` locally.

---

## Fallback: No Overleaf Premium

If your Overleaf account does not include GitHub sync:

1. In Overleaf: **Menu** -> **Download** -> **Source** (downloads a `.zip`)
2. Unzip into a local directory
3. Work with Claude Code locally
4. When done, re-upload to Overleaf: **New Project** -> **Upload Project**

This is manual but works for any Overleaf tier.

---

## Tips

- Always `git pull` before starting a Claude Code session to avoid merge conflicts
- Use `/session-save` before ending a session to preserve research state
- If you hit a merge conflict, resolve it locally, commit, and push
- Set `config/latex-root.txt` to your project's main `.tex` file for compile checks
