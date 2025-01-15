function dev --argument dir
	test -z $dir && set dir $PWD
	kitty --session ~/.myconfig/kitty/dev.session -d $dir #--detach
end
