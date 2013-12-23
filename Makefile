COFFEE = node_modules/.bin/coffee


.PHONY: all
all: \
		nginx.conf \
		$(patsubst assets/%,public/%,$(shell find assets -type f)) \
		public/style.css \
		public/concat.js


hashify.me/%:
	make -C hashify.me $*


nginx.conf: hashify.me/nginx.conf.default
	sed -e 's!<ROOT>!$(abspath $(@D))/public!' -e 's!\(hashify\.me;\)!docco.\1!' $< > $@


public/%: assets/%
	mkdir -p $(@D)
	cp $< $@


public/style.css: hashify.me/public/style.css lib/css/docco.hashify.css
	cat $^ > $@


public/concat.js: hashify.me/public/concat.js lib/js/docco.hashify.js
	cat $^ > $@

lib/js/%.js: src/coffee/%.coffee
	mkdir -p $(@D)
	cat $< | $(COFFEE) --compile --stdio > $@


.PHONY: setup
setup:
	git submodule update --init
	make -C hashify.me setup
	npm install


.PHONY: clean
clean:
	make -C hashify.me clean
	rm -rf lib/js public nginx.conf
