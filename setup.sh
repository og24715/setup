# brew
brew -v &> /dev/null
if [ $? -ne 0 ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "brew has already installed"
fi

# ansible
brew install ansible

# clone setup repository
curl -OL https://github.com/og24715/setup/archive/refs/heads/main.zip
unzip main.zip
cd setup-main

# deploy ansible
ansible-playbook ansible/playbook.yml
