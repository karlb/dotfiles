# install custom .bashrc
grep -q -F '. ~/.myconfig/.bashrc' ~/.bashrc || echo -e '\n. ~/.myconfig/.bashrc' >> ~/.bashrc

# link config files from ~/.myconfig to ~
ln -sfn ~/.myconfig/.vim ~/.vim
ln -sfn ~/.myconfig/.tmux ~/.tmux
ln -sfn ~/.myconfig/.sqliterc ~/.sqliterc

# copy templates (should contain an include/source to a file in .myconfig)
cp -rn ~/.myconfig/templates/.??* ~/

# mc: only copy file, since mc constantly changes some unimportant settings
mkdir -p ~/.config/mc
cp -f ~/.myconfig/.mc/ini ~/.config/mc/ini

# install tmux plugins
[ -e ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# install vim plugins 
[ -e ~/.vim/pack/minpac/opt/minpac ] || git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
vim +PackUpdate +qall  # "qall" quits vim after installing
