require('render-markdown').setup({
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki#render-modes
	render_modes = true,

	-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki#anti-conceal
	anti_conceal = {
		disabled_modes = { 'n', 'c' },
	},
});
