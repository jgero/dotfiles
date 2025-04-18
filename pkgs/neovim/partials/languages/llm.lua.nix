{ pkgs, ... }: ''
    require("llm").setup({
      model = "Refact-1_6B-fim",
      backend = "openai",
      url = "http://localhost:8080",
        tokens_to_clear = { "<|file_separator|>" },
  fim = {
    enabled = true,
    prefix = "<|fim_prefix|>",
    middle = "<|fim_middle|>",
    suffix = "<|fim_suffix|>",
  },
  --    fim = {
   --     enabled = true,
    ----    prefix = "<PRE> ",
      --  middle = "<MID>",
       -- suffix = "<SUF>",
     -- },
      request_body = {
        options = {
          temperature = 0.2,
          num_predict = 256,
        }
      },
      context_window = 2048,
      debounce_ms = 150,
      lsp = {
        bin_path = "${pkgs.llm-ls}/bin/llm-ls",
        cmd_env = { LLM_LOG_LEVEL = "DEBUG" },
        version = "${pkgs.llm-ls.version}"
      }
    })
''
