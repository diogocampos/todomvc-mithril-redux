build: node_modules/ clean
	./node_modules/.bin/brunch build --env production

watch: node_modules/ clean
	./node_modules/.bin/brunch watch --server

clean:
	rm -rf public/*

node_modules/: package.json
	npm install

.PHONY: build watch clean
