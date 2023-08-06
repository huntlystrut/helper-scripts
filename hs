#!/bin/sh
CMD_FROM_HISTORY=$(tail -r ~/.zsh_history | cut -s -d';' -f2 | gum filter)
eval "${CMD_FROM_HISTORY}"
