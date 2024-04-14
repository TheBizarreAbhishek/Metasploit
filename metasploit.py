#!/data/data/com.termux/files/usr/bin/bash

# Function to display logo
display_logo() {
    echo " __  __      _                  _       _ _"
    echo "|  \/  |    | |                | |     (_) |"
    echo "| \  / | ___| |_ __ _ ___ _ __ | | ___  _| |_"
    echo "| |\/| |/ _ \ __/ _\` / __| '_ \| |/ _ \| | __|"
    echo "| |  | |  __/ || (_| \__ \ |_) | | (_) | | |_"
    echo "|_|  |_|\___|\__\__,_|___/ .__/|_|\___/|_|\__|"
    echo "                         | |"
    echo "                         |_|    By Abhishek"
}
#clear screen
clear
# Display logo
display_logo
#function to center text
center() {
    local terminal_width=$(tput cols)
    local text_length=${#1}
    local spaces=$(( (terminal_width + text_length) / 2 ))
    printf "%${spaces}s\n" "$1"
}
# Loading spinner
echo "Loading..."
source <(echo "c3Bpbm5lcj0oICd8JyAnLycgJy0nICdcJyApOwoKY291bnQoKXsKICBzcGluICYKICBwaWQ9JCEKICBmb3IgaSBpbiBgc2VxIDEgMTBgCiAgZG8KICAgIHNsZWVwIDE7CiAgZG9uZQoKICBraWxsICRwaWQgIAp9CgpzcGluKCl7CiAgd2hpbGUgWyAxIF0KICBkbyAKICAgIGZvciBpIGluICR7c3Bpbm5lcltAXX07IAogICAgZG8gCiAgICAgIGVjaG8gLW5lICJcciRpIjsKICAgICAgc2xlZXAgMC4yOwogICAgZG9uZTsKICBkb25lCn0KCmNvdW50" | base64 -d)


echo "Dependencies installation..."
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"
python3 -m pip install requests

clear
display_logo

# Fix ruby BigDecimal 
#center "* Fix ruby BigDecimal"
#source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)


# Erase Old Metasploit Folder
echo "Erasing old metasploit folder..."
if [ -d "${PREFIX}/opt/metasploit-framework" ]; then
  rm -rf ${PREFIX}/opt/metasploit-framework
fi

clear
display_logo
# Download Metasploit
echo "Downloading Metasploit..."
if [ ! -d "${PREFIX}/opt" ]; then
  mkdir ${PREFIX}/opt
fi
git clone https://github.com/rapid7/metasploit-framework.git --depth=1 ${PREFIX}/opt/metasploit-framework

clear
display_logo
# Install Metasploit
echo "Installing Metasploit..."
cd ${PREFIX}/opt/metasploit-framework
gem install bundler
NOKOGIRI_VERSION=$(cat Gemfile.lock | grep -i nokogiri | sed 's/nokogiri [\(\)]/(/g' | cut -d ' ' -f 5 | grep -oP "(.).[[:digit:]][\w+]?[.].")
# by overriding cflags nokogiri will install or you can simply declare a void function 
#  you might have seen this error while installing nokogiri `xmlSetStructuredErrorFunc((void *)rb_error_list, Nokogiri_error_array_pusher);`
#  solution : void xmlSetStructuredErrorFunc(void *rb_error_list, void *Nokogiri_error_array_pusher); you can set any parameter name 
#  for sake of simplicity tweaking cflags is better than declaring a void function for every c file


gem install nokogiri -v $NOKOGIRI_VERSION -- --with-cflags="-Wno-implicit-function-declaration -Wno-deprecated-declarations -Wno-incompatible-function-pointer-types" --use-system-libraries
bundle install
gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j$(nproc --all)


# Link Metasploit Executables
ln -sf ${PREFIX}/opt/metasploit-framework/msfconsole ${PREFIX}/bin/
ln -sf ${PREFIX}/opt/metasploit-framework/msfvenom ${PREFIX}/bin/
ln -sf ${PREFIX}/opt/metasploit-framework/msfrpcd ${PREFIX}/bin/
termux-elf-cleaner ${PREFIX}/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so


clear
display_logo
echo "Installation Complete
echo -e "\nStart Metasploit using the command: msfconsole"
echo -e "\033[0m"

