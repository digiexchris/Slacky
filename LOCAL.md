# Running the pipeline locally

If you want to use the GitHub workflow to build locally, either to build your own packages or to develop the workflow, Act is a very useful tool.

This workflow uses docker and qemu to allow cross compiling arm64 packages using an x64 host. So it doesn't matter if you run this pipeline on arm or on x64, it should work as long as you're using linux. Currently tested on ubuntu 24.04 amd64.

The main reason for this is it can be hard for a github action to properly select and run on an arm64 runner, and github arm64 runners are currently emulated anyway. Plus, this allows for rolling this out to more architectures if they end up being needed.

## Prerequisites (Ubuntu)

### 1. Setup Flathub
Setup Flathub as a remote with user permissions:
```bash
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### 2. Install Git LFS
Git LFS is required by electron-builder:
```bash
sudo apt update
sudo apt install git-lfs
```

### 3. Install Node.js 24 and Yarn
Install NVM (Node Version Manager):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
```

Install Node.js 24 and Yarn:
```bash
nvm install 24
nvm use 24
npm install -g yarn
```

### 4. Install Docker
https://docs.docker.com/engine/install/

### 5. Install Act
```bash
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## Running the workflow

Navigate to the project root and run:
```bash
act --container-architecture=linux/aarch64 --container-options "--privileged --cap-add SYS_ADMIN --security-opt apparmor=unconfined --security-opt seccomp=unconfined"
```

# Native build

You can also build native packages for your host OS by calling yarn directly

``` #note: probably wrong, update later
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub org.freedesktop.Platform/aarch64/24.08 org.freedesktop.Sdk/aarch64/24.08 org.electronjs.Electron2.BaseApp/aarch64/stable -y
    corepack enable
    corepack prepare yarn@stable --activate
    yarn install

    yarn app:dir # builds, but doesn't pack
    yarn app:dist # builds and creates packages for your current arch/os (eg linux/amd64)
```



# Updating Dependencies
npm install
pipx install flatpak-node-generator
flatpak-node-generator npm ./package-lock.json
npm run build


