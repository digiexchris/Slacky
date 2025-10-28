- Building flatpak locally

setup flathub as a remote with user permissions https://flathub.org/en/setup

flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

ensure git-lfs is installed (required by electron-builder)

#if the dependencies have changed
pipx install git+https://github.com/flatpak/flatpak-builder-tools.git#subdirectory=node
npm install
flatpak-node-generator npm package-lock.json

#finally, build and install the flatpak
flatpak-builder build org.flathub.electron-sample-app.yml --install-deps-from=flathub --force-clean --user --install #omit --install if you don't want to install the built flatpak on your system
