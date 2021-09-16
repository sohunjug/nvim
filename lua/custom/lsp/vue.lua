local M = {}

M.config = {
   settings = {
      vetur = {
         experimental = {
            templateInterpolationService = true,
         },
         validation = {
            templateProps = true,
         },
         completion = {
            tagCasing = "initial",
            autoImport = true,
            useScaffoldSnippets = true,
         },
      },
   },
   flags = {
      debounce_text_changes = 150,
   },
}

return M
