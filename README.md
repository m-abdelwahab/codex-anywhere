# Codex Anywhere

Run OpenAI Codex on a persistent Railway server and connect to it securely over SSH. Deploy once, then use the Codex desktop app and ChatGPT mobile app to stay attached to the same remote environment.

## 1. Set up the Railway CLI

In a terminal, run:

```bash
bash <(curl -fsSL railway.com/install.sh) --agents -y
```

Then log in to Railway:

```bash
railway login
```

Railway opens your browser so you can finish signing in. If you do not have a Railway account yet, you can create one during this step.

## 2. Deploy the Railway template

Deploy the Railway template by clicking the **Deploy** button:

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/codex-anywhere?referralCode=thisismahmoud&utm_medium=integration&utm_source=template&utm_campaign=codex-anywhere)

The template does not require any secrets or environment variables.
It does require the included persistent volume mounted at `/data`; the container exits instead of storing Codex state on ephemeral disk if that mount is missing.

## 3. Set up SSH

Next, create an SSH key so your Mac can securely connect to the Railway server.

An SSH key has two parts:

- The private key stays on your Mac and should not be shared.
- The public key is safe to give to Railway.

Create a key:

```bash
ssh-keygen -t ed25519 -C "codex-anywhere"
```

`ssh-keygen` is interactive. Press Enter through the defaults. It looks like this:

```text
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/you/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/you/.ssh/id_ed25519
Your public key has been saved in /Users/you/.ssh/id_ed25519.pub
```

Register the public key with Railway:

```bash
railway ssh keys add --key ~/.ssh/id_ed25519.pub --name codex-anywhere
```

You should see output like:

```text
SSH key added: codex-anywhere
```

Codex reads remote connections from your Mac's `~/.ssh/config`, so add a named SSH host now:

```bash
railway ssh config --alias codex-anywhere --identity-file ~/.ssh/id_ed25519
```

The command is interactive. When Railway asks what to connect to, choose the project and service from the Codex Anywhere deployment.

## 4. Connect with the Codex app

Open the Codex desktop app and go to:

```text
Settings > Connections > SSH > Connect
```

Codex automatically detects hosts from your SSH config. Choose:

```text
codex-anywhere
```

If Codex asks you to confirm the host, approve it. The first connection may take a moment while Codex starts its remote app server through SSH.

When Codex asks for a remote project folder, use:

```text
/data
```

This template already installs the `codex` command on the Railway server and makes it available on the remote `PATH`.
Startup stores `/home/user` at `/data/home/user` and `/root` at `/data/root`, so shell config, CLI auth, caches, and user-local tools survive redeploys. Codex state is persisted with `CODEX_HOME=/data/.codex`; startup also links `/home/user/.codex` and `/root/.codex` there so chats, auth, config, and sessions survive even when the remote app server runs as root.

Packages installed into system paths like `/usr`, `/opt`, or `/usr/local` are still part of the image, not the volume. Add those tools to the `Dockerfile` if you need them after every redeploy. User-local installs, including `npm install -g` as `user`, go under `/home/user/.local` and persist.

After Codex connects, you can ask it to finish setup inside the remote machine:

```text
Run railway login --browserless and show me the login URL and code.
```

Then, if you plan to work with GitHub repositories:

```text
Run gh auth login and walk me through the prompts.
```

Now clone your repo into the persistent `/data` folder:

```text
Clone my repo into /data and inspect it.
```
