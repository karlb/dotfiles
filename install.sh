#!/bin/bash
# install custom .bashrc
touch ~/.bashrc
grep -q -F '. ~/.myconfig/.bashrc' ~/.bashrc || echo -e '\n. ~/.myconfig/.bashrc' >> ~/.bashrc

# link config files from ~/.myconfig to ~
ln -sfn ~/.myconfig/.vim ~/.vim
#rm -fr ~/.config/nvim/ && ln -sfn ~/.myconfig/nvim ~/.config/
mkdir -p ~/.config
ln -sfn ~/.myconfig/nvim ~/.config/
ln -sfn ~/.myconfig/kitty ~/.config/
ln -sfn ~/.myconfig/fish ~/.config/
ln -sfn ~/.myconfig/.tmux ~/.tmux
ln -sfn ~/.myconfig/.sqliterc ~/.sqliterc
ln -sfn ~/.myconfig/.Xmodmap ~/.Xmodmap

# link config files from ~/.myconfig/.config to ~/.config
for d in ~/.myconfig/.config/*
do
	for f in "$d"/*
	do
		target_dir=$(dirname ${f/.myconfig/})
		mkdir -p "$target_dir"
		ln -sfn "$f" "$target_dir"
	done
done

# copy templates (should contain an include/source to a file in .myconfig)
cp -rn ~/.myconfig/templates/.??* ~/

# mc: only copy file, since mc constantly changes some unimportant settings
mkdir -p ~/.config/mc
cp -f ~/.myconfig/.mc/ini ~/.config/mc/ini
