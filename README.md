# Dotfiles

```
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:jgero/dotfiles#nixpad
sudo nixos-install --flake github:jgero/dotfiles#nixpad --root /mnt
home-manager switch --flake .#
```

## TODO

- Implement [append only
backups](https://ruderich.org/simon/notes/append-only-backups-with-restic-and-rclone)
- Local LLM for nvim suggestions.
    - *Plugin options:*
    - https://github.com/huggingface/llm.nvim
    - https://github.com/milanglacier/minuet-ai.nvim
    - *LSPs:*
    - https://github.com/huggingface/llm-ls
    - *Serve model locally:*
    - https://ollama.com/
    - https://github.com/ggml-org/llama.cpp

[^1]: [NixOS Wiki - Impermanence](https://nixos.wiki/wiki/Impermanence)

