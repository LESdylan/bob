Here's everything, in order:

#### 1. IBM Bob IDE ####
# The site has no direct .deb link: ask its API for a signed URL (valid 60s), then download
URL=$(curl -sS -o /dev/null -w '%{redirect_url}' -X POST https://bob.ibm.com/api/download/bobide \
  -H 'Origin: https://bob.ibm.com' -H 'Referer: https://bob.ibm.com/download' \
  -F platform=linux -F 'version=1.126.0+bob2.1.0' -F architecture=amd64 -F packageType=deb)
mkdir -p ~/Downloads
curl -fsSL "$URL" -o ~/Downloads/IBM-Bob-linux-amd64-2.1.0.deb

# Don't let Bob's installer add Microsoft's VS Code apt repo, then install (needs sudo)
echo "bobide bobide/add-microsoft-repo boolean false" | sudo debconf-set-selections
sudo apt install -y ~/Downloads/IBM-Bob-linux-amd64-2.1.0.deb


#### 2. Node.js 24 LTS, in $HOME, no sudo (nvm needs bash; your shell is hellish) ####
V=v24.21.0; T=node-$V-linux-x64.tar.xz
cd /tmp
curl -fsSLO https://nodejs.org/dist/$V/$T
curl -fsSL https://nodejs.org/dist/$V/SHASUMS256.txt -o SHASUMS256.txt
grep " $T\$" SHASUMS256.txt | sha256sum -c -          # verify download
mkdir -p ~/.local/opt ~/.local/bin
tar -xJf $T -C ~/.local/opt
ln -sfn ~/.local/opt/node-$V-linux-x64 ~/.local/opt/node
for b in node npm npx corepack; do ln -sf ~/.local/opt/node/bin/$b ~/.local/bin/$b; done
npm config set prefix ~/.local                        # global npm installs without sudo


#### 3. IBM Bob Shell ####
curl -fsSL https://bob.ibm.com/download/bobshell.sh -o /tmp/bobshell.sh
bash /tmp/bobshell.sh --pm npm     # same as: curl -fsSL .../bobshell.sh | bash


#### 4. Check ####
bobide --version && node -v && npm -v && bob --version

Two notes: only step 1's apt install needed sudo, and I ran the downloads in the session scratchpad rather than /tmp, which makes no difference.

Your license-screen question is still open, by the way. Those three entries are documents to view, not choices. I was checking Bob Shell's code for the key that accepts and moves on when your message arrived. Say the word and I'll finish that.













