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


## 3. Set up SSH

Next, create an SSH key so your Mac can securely connect to the Railway server.

An SSH key has two parts:

- The private key stays on your Mac and **should not** be shared.
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
After configuration, you will need to log into Codex. 

Finally, click on the "new project" button from the sidebar and choose "Remote project". After that, click on "Add project". That's it!

## Next steps

You can pretty much work with Codex the same way you're used to. The difference is you now have a remote machine with its own isolated resources that you can access from anywhere.

If you plan to work with GitHub repositories, you can just ask Codex:

```text
Run gh auth login and walk me through the prompts.
```

Now clone your repo into the persistent `/data` folder:

```text
Clone my repo into /data and inspect it.
```

The Railway CLI and agent skills already come preconfigured. You'll also be automatically logged in after you connect, so you can just ask Codex to deploy your projects to Railway.
