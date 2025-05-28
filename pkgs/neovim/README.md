# Neovim: How it works

This package provides a pre-configured Neovim. The configuration is split into
"partials", wrapped as neovim packages. With this setup, the configuration can
be split into smaller parts which can be enabled or disabled, either through the
nix- or the Neovim-configuration. Additionally, this keeps the file structure of
non-generated parts of the configuration the same between the sources and
runtime, which makes it easy to map locations of errors thrown at runtime to the
configuration source file (with generated configuration this becomes difficult).

## Lua Configuration Partials

Each Lua partial is represented as an attrset and can have up to 5 attributes:

- `name` (string):\
  The name of the partial. This is required to give the resulting Neovim package
  a name. To avoid collisions, it is sensible to add a prefix to avoid possible
  name collisions with external plugins.
- `sources` (path):\
  The Lua sources of the partial. This is a path to a directory which contains
  the Lua files that should be added to the Neovim package.
- `plugins` (list of packages):\
  The (Neo)vim plugin packages which the configuration depends on. These plugins
  and their dependencies will be added to the runtimepath.
- `dependencies` (list of packages):\
  Dependencies are other packages/libraries/binaries that are required at
  runtime.
- `init` (string):\
  The `init.lua` file each Neovim package needs. If there are files in
  `sources`, this init file is expected to `require` those other sources. Can
  also contain other generated Lua configuration.
- `order` (int):\
  Specifies the order in which the partials are imported in the main `init.lua`
  entrypoint to the configuration. The default is 999, so packages with higher
  priority can be pushed to the front by specifying the value.
- `opt` (boolean):\
  Whether the plugin should be optional and not loaded on startup. Defaults to 
  `false`.

All partials are [collected in one file](partials/default.nix) and [converted to
derivations](lib/mkPack.nix).

## Packaging Plugins Into The Neovim Derivation

The partials, which are now plugin derivations, need to be wrapped into a list
of plugins, runtime dependencies and a main `init.lua` configuration entrypoint.
[This is pretty simple](lib/configureNeovimPlugins.nix) since sorting the
plugins, joining the dependencies together and generating the barrel file to
import all plugins is trivial.

By using `pkgs.neovim.override` a list of plugins can be specified which will
then be wrapped into the Neovim package. [A single
`wrapProgram`](lib/buildNeovimDerivation.nix) suffices then to add the custom
runtimepath and specifying the generated entrypoint file.

