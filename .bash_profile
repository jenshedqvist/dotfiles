# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Increase max files open limit
ulimit -n 2560

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Enable tab completion for regular git command
if [ -f $HOME/.git-completion ]; then
	source ~/.git-completion
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Check for RVM (Ruby Version Manager) and run or install
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
	# Load RVM into a shell session *as a function*
  source "$HOME/.rvm/scripts/rvm"
	# Add RVM to PATH for scripting
	export PATH="$PATH:$HOME/.rvm/bin"
else
  # Install RVM into a shell session *as a function*
	curl -sSL https://get.rvm.io | bash -s stable
	# Load RVM into a shell session *as a function*
	source "$HOME/.rvm/scripts/rvm"
	# Add RVM to PATH for scripting
	export PATH="$PATH:$HOME/.rvm/bin"
fi;

# Check for NVM (Node Version Manager) and install run or install
if [ -f $HOME/.nvm/nvm.sh ]; then
	# Active NVM
	source ~/.nvm/nvm.sh
else
	# Install NVM (Node Version Manager) into shell
	curl https://raw.githubusercontent.com/creationix/nvm/v0.15.0/install.sh | bash
	# Active NVV
	source ~/.nvm/nvm.sh
fi;
