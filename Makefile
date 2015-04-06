bin := $(shell npm bin)
lsc := $(bin)/lsc

build := build
lib := lib

docset_basename := LiveScript
docset_name := $(docset_basename).docset
docset := $(build)/$(docset_name)
docset_html := $(docset)/Contents/Resources/Documents

vendor := vendor
site := livescript.net
downloaded_doc := $(vendor)/$(site)


dev: clean build install
prod: clean build release

clean:
	rm -rf $(build)


.PHONY: build
build: static-content index bits-from-original-doc homepage


$(downloaded_doc):
	mkdir -p $(vendor)
	wget http://$(site)/ --directory-prefix=$(vendor) --page-requisites
bits-from-original-doc: $(downloaded_doc)
	mkdir -p $(docset_html)
	cp -R $(downloaded_doc)/* $(docset_html)


homepage_subpath := index.html
homepage := $(docset_html)/$(homepage_subpath)
downloaded_homepage := $(downloaded_doc)/$(homepage_subpath)
homepage: $(downloaded_doc)
	rm -rf $(homepage)
	$(lsc) $(lib)/generate-homepage $(downloaded_homepage) $(homepage)


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
