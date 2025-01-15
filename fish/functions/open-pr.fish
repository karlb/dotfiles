function open-pr
	set repo_name $(basename -s .git $(git remote get-url origin))
	open "https://github.com/celo-org/$repo_name/compare/$(git default-branch)...celo-org:$repo_name:$(git branch --show-current)?expand=1"
end
