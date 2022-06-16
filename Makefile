all:
	npx tailwindcss build -c tailwind.config.js -i ./src/input.css -o ./dist/output.css
	npx dessi --source=./src --target=./dist

serve:
	python3 -m http.server --dir ./dist
