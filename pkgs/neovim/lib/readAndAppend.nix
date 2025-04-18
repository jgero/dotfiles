fileList: builtins.concatStringsSep "\n" (map (file: builtins.readFile file) fileList)
