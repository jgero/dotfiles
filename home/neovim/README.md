# Neovim configuration with nix

## WARNINGS

Changing something in the extra configuration string and doing a rebuild and switch is NOT
sufficient for applying all configuration changes. At the moment everything is directly generated
into one file. Because of the inner workings of packer and how it saves and loads plugin
configuration an additional `:PackerCompile` is necessary to apply plugin configuration.

## TODO

- restructure Lua strings in `default.nix` to either split it up into smaller chunks or
  alternatively offload it into actual Lua files so LSP features can be used while developing the
  Lua configuration
