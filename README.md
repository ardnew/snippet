# snippet

A simple command-line tool with auto-completion for quickly printing regurgitated blobs

- Uses native filesystem as storage/organization for stupid simple maintenance
- Strictly _**zero processing or formatting**_ of snippets' content

## Overview

`snippet` prints the contents of files (snippets, typically strings of text) from a snippet directory. It's useful for inserting obnoxious Unicode symbols or frequently-used text snippets using easy-to-type/remember file names (with auto-completion).

```bash
make help  # describe all available targets
```

## Installation

```bash
make install
```

This installs to `~/.local` by default and includes shell completion for your current shell (bash, zsh, or fish).

To install to a different location:

```bash
make install PREFIX=/usr/local
```

### Individual Installation Targets

```bash
make install-bin              # Install binary only
make install-data             # Install snippet data files only
make install-bash-completion  # Install bash completion
make install-zsh-completion   # Install zsh completion
make install-fish-completion  # Install fish completion
```

## Usage

```bash
snippet [OPTIONS] <file1> [file2 ...]
snippet [OPTIONS] -c NAME [TEXT...]
```

### Options

- `-c, --create NAME [TEXT...]` - Create a new snippet with NAME, containing all TEXT args, if provided; otherwise, content initialized via stdin. Must be the last CLI option given; all following arguments are TEXT content.
- `-d, --dir DIR` - Directory containing snippet files (default: `$SNIPPET_DIR`). Last value wins if repeated.
- `-l, --list` - List all available snippet files
- `-s, --separator SEP` - Use SEP as separator between files (default: `\n`)
- `-h, --help` - Show this help message

### Flag Ordering

Options other than `-c` may appear in any order. `-c` must be the last option because every argument after NAME is consumed as snippet content.

### Examples

```bash
# Print contents of angl and mult separated by the default separator
snippet angl mult

# Print contents of angl and mult separated by newlines and dashes
snippet -s $'\n---\n' angl mult

# List all available snippets
snippet --list

# Create a snippet from arguments
snippet --create shrug '¯\_(°_o)_/¯'

# Create a snippet from stdin
echo '(╯°□°）╯︵ ┻━┻' | snippet -c flip
snippet -c relax < <( echo '┬─┬ ノ( ゜-゜ノ)' )

# Use a custom directory with --create
snippet -d ~/proverbs --create heday \
  Buy a man eat fish, he day, teach fish man to a lifetime
```

## Default Snippets

The release package includes several Unicode character snippets:

- `angl` / `angr` - angle brackets (‹ ›)
- `mult` - multiplication sign (×)
- `ellipses` - horizontal ellipsis (…)
- `bullet` - bullet point (•)
- `emdash` / `endash` - em/en dashes (— –)
- `degrees` - degree symbol (°)
- `prime` / `dblprime` - prime symbols (′ ″)
- and more...
