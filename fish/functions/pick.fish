function pick --description 'Extract regex capture groups with ripgrep'
    rg $argv -r '$1 $2 $3 $4 $5 $6 $7 $8 $9'
end
