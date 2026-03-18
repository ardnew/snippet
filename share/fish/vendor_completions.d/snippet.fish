# Fish completion script for snippet tool

# Get snippet directory
function __snippet_dir
    if set -q SNIPPET_DIR
        echo $SNIPPET_DIR
    else
        echo "$HOME/.local/share/snippet"
    end
end

# List available snippet files
function __snippet_list_snippets
    set snippet_dir (__snippet_dir)
    if test -d $snippet_dir
        for file in $snippet_dir/*
            if test -f $file -a -r $file
                basename $file
            end
        end
    end
end

# Completion for snippet files
complete -c snippet -f -a '(__snippet_list_snippets)' -d 'Snippet file'

# Options
complete -c snippet -s c -l create -d 'Create a new snippet' -r
complete -c snippet -s d -l dir -d 'Directory containing snippet files' -r -a '(__fish_complete_directories)'
complete -c snippet -s l -l list -d 'List all available snippets'
complete -c snippet -s s -l separator -d 'Separator to use between snippets' -r
complete -c snippet -s h -l help -d 'Show help message'
