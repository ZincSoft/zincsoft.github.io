all: assets/style.css

assets/style.css: assets/_index.scss assets/_base.scss assets/_utilities.scss assets/_variables.scss assets/_components.scss
	sass assets/_index.scss assets/style.css
