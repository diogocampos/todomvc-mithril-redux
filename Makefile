build: node_modules/ clean
	node_modules/.bin/brunch build --env production

watch: node_modules/ clean
	node_modules/.bin/brunch watch --server

deploy: public/ build
	cd public && git add . && git commit -em 'Deploy to GitHub Pages'
	git push origin gh-pages

clean:
	rm -rf public/*


node_modules/: package.json
	npm install

public/:
	git worktree add ./public gh-pages


.PHONY: build watch deploy clean
