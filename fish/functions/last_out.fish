function last_out
	if test -n "$KITTY_WINDOW_ID"
		kitty @ get-text --extent last_non_empty_output
	else
		~/code/experiments/plumb/last_out
	end
end
