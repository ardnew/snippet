#!/usr/bin/env bash
# Bash completion script for snippet tool

_snippet_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Options that take arguments
    if [[ "$prev" == "-s" || "$prev" == "--separator" ]]; then
        # No completion for separator value
        return 0
    fi

    if [[ "$prev" == "-c" || "$prev" == "--create" ]]; then
        # No completion for create name (user provides a new name)
        return 0
    fi

    if [[ "$prev" == "-d" || "$prev" == "--dir" ]]; then
        # Complete directories for --dir
        COMPREPLY=( $(compgen -d -- "$cur") )
        return 0
    fi

    # Get the directory where snippet-tool is located
    local snippet_tool_path
    snippet_tool_path="$(command -v snippet 2>/dev/null)"
    
    if [[ -z "$snippet_tool_path" ]]; then
        # Fallback: try to find it relative to this completion script
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        snippet_tool_path="$script_dir/snippet"
    fi
    
    local snippet_dir=${SNIPPET_DIR:-"${HOME}/.local/share/snippet"}

    # If current word starts with a dash, complete options
    if [[ "$cur" == -* ]]; then
        opts="-c --create -d --dir -l --list -s --separator -h --help"
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return 0
    fi

    # Complete with available snippet files
    if [[ -d "$snippet_dir" ]]; then
        local files
        while read -re fi; do
            local afi="$snippet_dir/$fi"
            [[ ! -f "${afi}" || ! -r "${afi}" ]] ||
                files+=( "${fi}" )
        done < <(command ls -1 "$snippet_dir" 2>/dev/null)
        COMPREPLY=( $(compgen -W "${files[*]}" -- "$cur") )
    fi

    return 0
}

# Register the completion function
complete -F _snippet_completion snippet
