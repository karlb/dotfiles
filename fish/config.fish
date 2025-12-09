set fish_greeting

export PATH="$PATH:/Users/karl/.foundry/bin"

# pnpm
set -gx PNPM_HOME "/Users/karl/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

direnv hook fish | source


source /Users/karl/.docker/init-fish.sh || true # Added by Docker Desktop

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/karl/tools/google-cloud-sdk/path.fish.inc' ]; . '/Users/karl/tools/google-cloud-sdk/path.fish.inc'; end

nvm use 18 > /dev/null
