deploy:
	fly deploy
serve:
	iex -S mix phx.server --open
logs:
	flyctl --app elixir-jp-calendar logs
setup:
	mix setup
	npm --prefix assets install
