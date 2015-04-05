bin := $(shell npm bin)
lsc := $(bin)/lsc

build := build
lib := lib

docset_basename := LiveScript
docset_name := $(docset_basename).docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents


dev: clean build install
prod: clean build release

clean:
	rm -rf $(build)


.PHONY: build
build: static-content index


static-content:
	mkdir -p $(docset)
	cp -R static/* $(docset)


index:
	mkdir -p $(docset)/Contents/Resources
	DOCSET_PATH=$(docset) $(lsc) $(lib)/generate-index


install:
	open $(docset)
release:
	cd $(build); tar --exclude='.DS_Store' -cvzf $(docset_basename).tgz $(docset_name)
