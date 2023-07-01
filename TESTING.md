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

