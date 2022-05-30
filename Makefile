PATH := $(PWD)/node_modules/.bin:$(PATH)

SOURCES := $(wildcard src/*.js)
DIST := $(SOURCES:src/%=dist/%)

all: lint dist min sass

publish: lint dist
	npm publish

lint:
	npx standard $(SOURCES)

dist:
	rm -rf $@
	npx babel src -d $@

min: assets/js/main.min.js

assets/js/main.min.js: \
	assets/js/vendor/fuse.min.js \
	assets/js/sidebar.js \
	assets/js/search.js \
	assets/js/main.js \
	assets/js/vendor/prism.min.js
	cat $^ | uglifyjs > $@

sass:
	npx node-sass --output-style compressed scss -o assets/css

sass-dev:
	npx node-sass scss -o assets/css --sourcemap=inline

clean:
	rm -rf $(DIST) assets/js/main.min.js assets/css

rebuild:
	rm -rf node_modules && yarn

.PHONY: all dist min sass clean
