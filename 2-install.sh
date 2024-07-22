# installing all kinds of stuff
yay -S --needed --noconfirm \
	# Editor
	# TODO: install packages here as well
	neovim neovim-plug-git python-pynvim python2-pynvim ruby-neovim nvim-yarp-git
	# Software
	firefox keepassxc syncthing signal-desktop
	# Devlopment tools
	docker docker-compose nodejs npm make pass-git-helper julia

# install nvim plugins
nvim +PlugInstall +qall
