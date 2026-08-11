local home = os.getenv('HOME')
local jdtls = require('jdtls')

-- Find root directory of the project
local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)

-- If no project root is found, default to the directory of the current file
if root_dir == "" or root_dir == nil then
  root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
end

-- Calculate a unique workspace name based on the root directory
local project_name = vim.fs.basename(root_dir)
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

-- Configure capabilities for autocompletion
local blink_ok, blink = pcall(require, 'blink.cmp')
local capabilities = blink_ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

local cmd = {
  vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls'),
  '-data', workspace_dir,
}

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "junit.framework.TestCase.*",
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.backend.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "regex.Pattern.compile",
        },
        filteredTypes = {
          "com.sun.*",
          "sun.*",
          "jdk.*",
          "org.graalvm.*",
          "oracle.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}

-- Start or attach the language server
jdtls.start_or_attach(config)
