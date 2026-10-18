return {
  settings = {
    ty = {
      -- Insert the call parentheses on accepting a function completion, like
      -- vtsls (completeFunctionCalls) and rust-analyzer (callable snippets) do.
      completions = { completeFunctionParentheses = true },
    },
  },
}
