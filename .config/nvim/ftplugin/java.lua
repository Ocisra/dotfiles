-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/home/ocisra/.cache/java/' .. project_name


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
      -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
     cmd = {

    -- 💀
    'java', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', '/home/ocisra/build/jdtls/src/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', '/home/ocisra/build/jdtls/src/config_linux',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', '.clang-format'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
      bundles = {
          vim.fn.glob("/home/ocisra/build/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.41.0.jar")
      }
  },
}

config['on_attach'] = function(client, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.
  -- You can use the `JdtHotcodeReplace` command to trigger it manually
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

vim.keymap.set('n', '<F7>', "<cmd>lua require'jdtls.dap'.setup_dap_main_class_configs()<CR>", {noremap=true})
