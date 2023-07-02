# write tests for the following

```
pis-Mac:~ pi$ ls -lta
total 504
drwx------   5 pi    staff     160 Jul  1 16:22 .bash_sessions
-rw-------   1 pi    staff     316 Jul  1 16:22 .bash_history
drwxr-x---+ 39 pi    staff    1248 Jul  1 16:19 .
-rw-------   1 pi    staff    1586 Jul  1 16:17 .viminfo
-rw-r--r--   1 pi    staff      99 Jul  1 16:17 .bashrc
-rw-r--r--   1 pi    staff      53 Jul  1 16:17 .profile
drwxr-xr-x   3 pi    staff      96 Jul  1 16:13 bin
-rw-r--r--   1 pi    staff     206 Jul  1 16:13 .zshrc
-rw-r--r--   1 pi    staff     329 Jul  1 16:13 .fzf.zsh
-rw-r--r--   1 pi    staff     331 Jul  1 16:13 .fzf.bash
-rw-r--r--   1 pi    staff    2454 Jul  1 16:13 compat.sh
-rw-r--r--   1 pi    staff    2382 Jul  1 16:13 compat.bash
drwxr-xr-x   4 pi    staff     128 Jul  1 16:10 .pyenv
drwxr-xr-x   7 pi    staff     224 Jul  1 16:09 .rustup
drwxr-xr-x   4 pi    staff     128 Jul  1 16:09 .cargo
drwx------   5 pi    staff     160 Jul  1 16:09 .zsh_sessions
-rw-r--r--   1 pi    staff   47860 Jul  1 16:09 .zcompdump
drwxr-xr-x   4 pi    staff     128 Jul  1 16:06 .local
drwxr-xr-x   2 pi    staff      64 Jul  1 16:06 .bin
-rw-r--r--   1 pi    staff  146949 Jul  1 15:57 .Brewfile.lock.json
lrwxr-xr-x   1 pi    staff      37 Jul  1 15:36 .Brewfile -> /Users/pi/.homebrew-brewfile/Brewfile
-rw-r--r--   1 root  staff     164 Jul  1 15:28 .zshrc~
drwx------   3 pi    staff      96 Jul  1 15:26 .config
drwxr-xr-x   8 pi    staff     256 Jul  1 15:12 .homebrew-brewfile
-rw-r--r--   1 pi    staff      53 Jul  1 14:40 .gitconfig
-rw-------   1 pi    staff      11 Jul  1 14:25 .zsh_history
drwxr-xr-x   6 pi    staff     192 Jul  1 14:23 .hyper_plugins
-rw-r--r--   1 pi    staff    6975 Jul  1 14:23 .hyper.js
drwx------+  5 pi    staff     160 Jul  1 14:21 Downloads
drwx------   4 pi    staff     128 Jun 20 16:38 Movies
drwx------@ 73 pi    staff    2336 Jun 20 16:38 Library
drwx------+  4 pi    staff     128 May 31 17:54 Pictures
drwx------+  2 pi    staff      64 May 31 16:36 .Trash
-r--------   1 pi    staff       7 May 31 16:35 .CFUserTextEncoding
drwx------+  3 pi    staff      96 May 31 16:34 Documents
drwxr-xr-x+  4 pi    staff     128 May 31 16:34 Public
drwx------+  3 pi    staff      96 May 31 16:34 Desktop
drwx------+  3 pi    staff      96 May 31 16:34 Music
drwxr-xr-x   5 root  admin     160 May  3 00:53 ..
pis-Mac:~ pi$ cc


pis-Mac:~ pi$ type pyenv
pyenv is a function
pyenv ()
{
    local command;
    command="${1:-}";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in
        activate | deactivate | rehash | shell | virtualenvwrapper | virtualenvwrapper_lazy)
            eval "$(pyenv "sh-$command" "$@")"
        ;;
        *)
            command pyenv "$command" "$@"
        ;;
    esac
}
pis-Mac:~ pi$

pis-Mac:~ pi$ type asdf
asdf is /usr/local/bin/asdf
pis-Mac:~ pi$



```

# asdf info

```
pis-Mac:~ pi$ asdf info
OS:
Darwin pis-Mac.local 21.6.0 Darwin Kernel Version 21.6.0: Mon Apr 24 21:10:53 PDT 2023; root:xnu-8020.240.18.701.5~1/RELEASE_X86_64 x86_64

SHELL:
zsh 5.8.1 (x86_64-apple-darwin21.0)

BASH VERSION:
5.2.15(1)-release

ASDF VERSION:
v0.12.0

ASDF INTERNAL VARIABLES:
ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=.tool-versions
ASDF_DATA_DIR=/Users/pi/.asdf
ASDF_DIR=/usr/local/Cellar/asdf/0.12.0/libexec
ASDF_CONFIG_FILE=/Users/pi/.asdfrc

No plugins installed
ASDF INSTALLED PLUGINS:


pis-Mac:~ pi$
```

# pyenv

```
pi@pis-Mac ~/.local/share/chezmoi feature-macos
❯ python -c "import sys;print(sys.executable)"
/Users/pi/.pyenv/versions/3.10.12/bin/python
```

# fnm

```
pi@pis-Mac ~/.local/share/chezmoi feature-macos
❯ fnm env
export PATH="/Users/pi/Library/Caches/fnm_multishells/98284_1688335764845/bin":$PATH
export FNM_DIR="/Users/pi/Library/Application Support/fnm"
export FNM_LOGLEVEL="info"
export FNM_ARCH="x64"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_MULTISHELL_PATH="/Users/pi/Library/Caches/fnm_multishells/98284_1688335764845"
export FNM_VERSION_FILE_STRATEGY="local"
rehash
```

# fnm env

```
pi@pis-Mac ~/.local/share/chezmoi feature-macos
❯ fnm env --use-on-cd
export PATH="/Users/pi/Library/Caches/fnm_multishells/99750_1688336380148/bin":$PATH
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_DIR="/Users/pi/Library/Application Support/fnm"
export FNM_LOGLEVEL="info"
export FNM_ARCH="x64"
export FNM_MULTISHELL_PATH="/Users/pi/Library/Caches/fnm_multishells/99750_1688336380148"
autoload -U add-zsh-hook
_fnm_autoload_hook () {
    if [[ -f .node-version || -f .nvmrc ]]; then
    fnm use --silent-if-unchanged
fi

}

add-zsh-hook chpwd _fnm_autoload_hook \
    && _fnm_autoload_hook

rehash
```

# echo fpath

```
pi@pis-Mac ~/.local/share/chezmoi feature-macos
❯ echo $fpath | tr ' ' '\n'
/Users/pi/.sheldon/repos/github.com/ohmyzsh/ohmyzsh/functions
/Users/pi/.sheldon/repos/github.com/ohmyzsh/ohmyzsh/completions
/Users/pi/.sheldon/repos/github.com/ohmyzsh/ohmyzsh/cache/completions
/usr/local/opt/pyenv/completions
/Users/pi/.asdf/completions
/usr/local/share/zsh/site-functions
/usr/local/Cellar/zsh/5.9/share/zsh/functions
/Users/pi/.sheldon/repos/github.com/zsh-users/zsh-completions/src
/Users/pi/.zsh/completions
/Users/pi/.sheldon/repos/github.com/zdharma-continuum/fast-syntax-highlighting
```

# echo zshrc

```
pi@pis-Mac ~/.local/share/chezmoi feature-macos
❯ cat ~/.zshrc
#!/usr/bin/env zsh

# Uncomment to profile startup
# zmodload zsh/zprof

if [[ "$OSTYPE" == linux* ]]; then
    # XDG configuration for linux
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
fi

# Makes path a unique array preventing duplicates
typeset -U path
typeset -U fpath
# typeset -U cdpath
# typeset -U mailpath

# Source sheldon plugins
source "/Users/pi/.sheldon/repos/github.com/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
source "/Users/pi/.sheldon/repos/github.com/sindresorhus/pure/async.zsh"
source "/Users/pi/.sheldon/repos/github.com/sindresorhus/pure/pure.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/asdf/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/centos/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/cheat/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/direnv/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/fzf/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/gpg/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/invokeai/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/pyenv/env.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/asdf/path.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/centos/path.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/fzf/path.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/path.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/pyenv/path.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/rust/path.zsh"
source "/Users/pi/.sheldon/repos/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/config.zsh"
source "/Users/pi/.local/share/chezmoi/home/shell/config.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/brew/completion.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/chezmoi/completion.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/fzf/completion.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/fzf/keybinding.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/keybinding.zsh"
zsh-defer source "/Users/pi/.sheldon/repos/github.com/MichaelAquilina/zsh-you-should-use/zsh-you-should-use.plugin.zsh"
source "/Users/pi/.sheldon/repos/github.com/ohmyzsh/ohmyzsh/oh-my-zsh.sh"
zsh-defer source "/Users/pi/.sheldon/repos/github.com/ohmyzsh/ohmyzsh/plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh"
zsh-defer source "/Users/pi/.sheldon/repos/github.com/bossjones/boss-git-zsh-plugin/boss-git.plugin.zsh"
zsh-defer source "/Users/pi/.sheldon/repos/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "/Users/pi/.sheldon/repos/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/Users/pi/.sheldon/repos/github.com/zsh-hooks/zsh-hooks/zsh-hooks.plugin.zsh"
zsh-defer source "/usr/local/opt/asdf/libexec/asdf.sh"
zsh-defer -t 0.5 source "/Users/pi/.sheldon/repos/github.com/urbainvaes/fzf-marks/fzf-marks.plugin.zsh"
zsh-defer -t 0.5 source "/Users/pi/.sheldon/repos/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
zsh-defer -t 0.5 source "/Users/pi/.sheldon/repos/github.com/joel-porquet/zsh-dircolors-solarized/zsh-dircolors-solarized.zsh"
zsh-defer source "/Users/pi/.local/share/chezmoi/home/shell/compinit.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ------

```
