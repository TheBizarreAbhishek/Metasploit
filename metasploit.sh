#!/data/data/com.termux/files/usr/bin/bash
#banner 
display_logo() {
    # Define the logo lines
    local logo=(
        " __  __      _                  _       _ _"
        "|  \/  |    | |                | |     (_) |"
        "| \  / | ___| |_ __ _ ___ _ __ | | ___  _| |_"
        "| |\/| |/ _ \ __/ _\` / __| '_ \| |/ _ \| | __|"
        "| |  | |  __/ || (_| \__ \ |_) | | (_) | | |_"
        "|_|  |_|\___|\__\__,_|___/ .__/|_|\___/|_|\__|"
        "                         | |"
        "                         |_|    By Abhishek"
    )

    # Calculate the length of the longest line in the logo
    local longest_line_length=0
    for line in "${logo[@]}"; do
        local line_length=${#line}
        if (( line_length > longest_line_length )); then
            longest_line_length=$line_length
        fi
    done

    # Calculate the number of spaces to add before the logo to center it
    local spaces=$(( (terminal_width + longest_line_length) / 2 ))

    # Print each line of the logo with the required number of spaces before it
    for line in "${logo[@]}"; do
        printf "%${spaces}s\n" "$line"
    done
}
clear
display_logo

# Loading spinner
echo "Loading..."
source <(echo "c3Bpbm5lcj0oICd8JyAnLycgJy0nICdcJyApOwoKY291bnQoKXsKICBzcGluICYKICBwaWQ9JCEKICBmb3IgaSBpbiBgc2VxIDEgMTBgCiAgZG8KICAgIHNsZWVwIDE7CiAgZG9uZQoKICBraWxsICRwaWQgIAp9CgpzcGluKCl7CiAgd2hpbGUgWyAxIF0KICBkbyAKICAgIGZvciBpIGluICR7c3Bpbm5lcltAXX07IAogICAgZG8gCiAgICAgIGVjaG8gLW5lICJcciRpIjsKICAgICAgc2xlZXAgMC4yOwogICAgZG9uZTsKICBkb25lCn0KCmNvdW50" | base64 -d)

# Dependencies Installation
echo -e "\e[93mDependencies Installation...\e[0m"

pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"
python3 -m pip install requests

# Fix ruby BigDecimal 
echo -e "\e[93mFix ruby BigDecimal\e[0m"

#source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)

# Erase Old Metasploit Folder
echo -e "\e[93mErasing old metasploit folder...\e[0m"

if [ -d "${PREFIX}/opt/metasploit-framework" ]; then
  rm -rf ${PREFIX}/opt/metasploit-framework
fi

# Download Metasploit
echo -e "\e[93mDownloading Metasploit\e[0m"

if [ ! -d "${PREFIX}/opt" ]; then
  mkdir ${PREFIX}/opt
fi
git clone https://github.com/rapid7/metasploit-framework.git --depth=1 ${PREFIX}/opt/metasploit-framework

# Install Metasploit
echo -e "\e[93mInstalling Metasploit\e[0m"

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
echo -e "\033[32m" # Blue color
echo "Installation complete"
echo -e "\nStart Metasploit using the command: msfconsole"
echo -e "\033[0m" # Reset color
