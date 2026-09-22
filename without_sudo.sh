#### 1. IBM Bob IDE — no root ####
  # Same signed-URL download as before
  URL=$(curl -sS -o /dev/null -w '%{redirect_url}' -X POST https://bob.ibm.com/api/download/bobide \
    -H 'Origin: https://bob.ibm.com' -H 'Referer: https://bob.ibm.com/download' \
    -F platform=linux -F 'version=1.126.0+bob2.1.0' -F architecture=amd64 -F packageType=deb)
  mkdir -p ~/Downloads && curl -fsSL "$URL" -o ~/Downloads/IBM-Bob.deb

  # Unpack into $HOME instead of installing the package
  mkdir -p ~/.local/opt ~/.local/bin ~/.local/share/applications ~/.local/share/pixmaps
  rm -rf ~/.local/opt/bobide ~/.local/opt/bob-tmp
  dpkg-deb -x ~/Downloads/IBM-Bob.deb ~/.local/opt/bob-tmp
  mv ~/.local/opt/bob-tmp/usr/share/bobide ~/.local/opt/bobide
  cp ~/.local/opt/bob-tmp/usr/share/pixmaps/bobide.png ~/.local/share/pixmaps/
  rm -rf ~/.local/opt/bob-tmp

  # Launcher (--no-sandbox is required — see note below)
  printf '#!/bin/sh\nexec "$HOME/.local/opt/bobide/bin/bobide" --no-sandbox "$@"\n' > ~/.local/bin/bobide
  chmod +x ~/.local/bin/bobide

  # App-menu entry
  cat > ~/.local/share/applications/bobide.desktop <<EOF
  [Desktop Entry]
  Name=IBM Bob
  Exec=$HOME/.local/bin/bobide %F
  Icon=$HOME/.local/share/pixmaps/bobide.png
  Type=Application
  StartupWMClass=IBM Bob
  Categories=TextEditor;Development;IDE;
  MimeType=text/plain;inode/directory;application/x-bobide-workspace;
  EOF
  update-desktop-database ~/.local/share/applications 2>/dev/null


  #### 2. Node.js 24 LTS — no root ####
  V=v24.21.0; T=node-$V-linux-x64.tar.xz
  cd /tmp
  curl -fsSLO https://nodejs.org/dist/$V/$T
  curl -fsSL https://nodejs.org/dist/$V/SHASUMS256.txt -o SHASUMS256.txt
  grep " $T\$" SHASUMS256.txt | sha256sum -c -
  mkdir -p ~/.local/opt ~/.local/bin
  tar -xJf $T -C ~/.local/opt
  ln -sfn ~/.local/opt/node-$V-linux-x64 ~/.local/opt/node
  for b in node npm npx corepack; do ln -sf ~/.local/opt/node/bin/$b ~/.local/bin/$b; done
  npm config set prefix ~/.local


  #### 3. IBM Bob Shell — no root ####
  curl -fsSL https://bob.ibm.com/download/bobshell.sh -o /tmp/bobshell.sh
  bash /tmp/bobshell.sh --pm npm


  #### 4. Check ####
  bobide --version && node -v && npm -v && bob --version
