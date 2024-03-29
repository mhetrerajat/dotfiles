return {
	-- Mason
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		config = function()
		end,
	},


	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true, build = ":MasonUpdate" },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       opts = {} },


			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
		config = function()
			-- LSP settings.
			--  This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				-- NOTE: Remember that lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself
				-- many times.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end
					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				-- Custom Keymaps
				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
				nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
				nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

				-- See `:help K` for why this keymap
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				-- Lesser used LSP functionality
				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'Format current buffer with LSP' })
				vim.api.nvim_set_keymap("n", "<leader>f", ":Format<CR>", {})
			end

			-- Language Servers
			local servers = {
				-- clangd = {},
				-- gopls = {},
				pyright = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "off",
						},
					},
				},
				rust_analyzer = {},
				-- tsserver = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				jsonls = {},
				yamlls = {},
				taplo = {}
			}

			-- Setup neovim lua configuration
			require('neodev').setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'
			mason_lspconfig.setup {
				ensure_installed = vim.tbl_keys(servers),
			}
			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					}
				end,
			}

			-- Autoformat after saving the file



			-- nvim-cmp setup
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			}
		end,
	},



	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		-- event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip'
		},
		config = function()
			--
		end,
	},


	-- formatting
	--[[ {
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		lazy = true,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				border = "rounded",
				update_in_insert = vim.diagnostic.config().update_in_insert,
				sources = {

					-- diagnostics
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.diagnostics.zsh,

					-- linters
					null_ls.builtins.formatting.ruff,

					-- formatting
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.sqlfluff.with({
						extra_args = { "--dialect", "postgres" },
					}),
					null_ls.builtins.formatting.taplo

				},
			})
		end
	} ]]



}
