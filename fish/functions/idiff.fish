function idiff --description 'idiff <revision> [<files>...] - Interactive git diff with fzf preview'
# Example idiff HEAD~ ":(exclude)Cargo.lock"
set -x REVISION $argv[1]
if test -z "$REVISION"
	set REVISION HEAD
end
set FILES $argv[2..-1]
set -q FILES; or set FILES .
git diff --color=always --stat-width=$COLUMNS --stat $REVISION -- $FILES | \
      ghead -n -1 | \
      fzf --preview 'GIT_EXTERNAL_DIFF="difft --color always --width $FZF_PREVIEW_COLUMNS" git diff $REVISION -- "$(echo {} | cut -d "|" -f 1 | xargs)"' \
	  --preview-window=bottom:80%:wrap --ansi --layout=reverse
end
