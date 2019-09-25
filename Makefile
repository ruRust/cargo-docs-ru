TARGET_ROOT = target

clean:
	rm -rf $(TARGET_ROOT)

# === Documentation

DOCS := index faq config guide manifest build-script pkgid-spec crates-io \
	environment-variables specifying-dependencies source-replacement \
	policies machine-readable-output 
DOC_DIR := target/doc
DOC_OPTS := --markdown-no-toc \
		--markdown-css stylesheets/normalize.css \
		--markdown-css stylesheets/all.css \
		--markdown-css stylesheets/prism.css \
		--html-in-header src/doc/html-headers.html \
		--html-before-content src/doc/header.html \
		--html-after-content src/doc/footer.html
ASSETS := images/noise.png images/forkme.png images/Cargo-Logo-Small.png \
	stylesheets/all.css stylesheets/normalize.css javascripts/prism.js \
	javascripts/all.js stylesheets/prism.css images/circle-with-i.png \
	images/search.png images/org-level-acl.png images/auth-level-acl.png \
	favicon.ico

doc: $(foreach doc,$(DOCS),target/doc/$(doc).html) \
	$(foreach asset,$(ASSETS),target/doc/$(asset)) \

$(DOC_DIR)/%.html: src/doc/%.md src/doc/html-headers.html src/doc/header.html src/doc/footer.html
	@mkdir -p $(@D)
	rustdoc $< -o $(@D) $(DOC_OPTS)

$(DOC_DIR)/%: src/doc/%
	@mkdir -p $(@D)
	cp $< $@
