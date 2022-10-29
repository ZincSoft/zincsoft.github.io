all:
	npx tailwindcss build -c tailwind.config.js -i ./src/input.css -o ./dist/output.css
	npx dessi --ignore=./src/projects/catnet/rfc.thisisashitsystem.bak --source=./src --target=./dist

serve:
	python3 -m http.server --dir ./dist
