build: clean
	brunch build --env production

watch: clean
	brunch watch --server

clean:
	rm -rf public/*
