NAME = EDIT_ME
SLIDES = $(NAME)-slides.html
SLIDES_DIST = $(NAME)-slides-standalone.html
STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/docbook-xsl
SLIDES_STYLESHEET = $(wildcard slides.css)
IMAGES = $(wildcard *.png)
ASSETS = $(wildcard $(IMAGES) $(SLIDES_STYLESHEET))

all: $(NAME).html $(NAME).pdf $(SLIDES)
dist: $(SLIDES_DIST) $(ASSETS)
	mkdir -p dist
	# download external references, e.g. slidy CSS and JS
	sed -nE 's?.*\b(href|src)="(http://[^"]+)".*?\2?p' $< | xargs wget --directory-prefix dist
	ls dist/*.gz | xargs --no-run-if-empty gunzip
	if [ -n "$(ASSETS)" ]; then cp $(ASSETS) dist; fi
	# modify external references to point to downloaded assets
	sed -E 's?\b(href|src)="(http://[^"]+/([^"]+))"?\1="\3"?; s?\b(href|src)="(.*)\.gz"?\1="\2"?' $< > dist/$<

$(NAME).xml: $(NAME).otl
	OTL docbook <$< >$@

$(NAME).html: $(NAME).xml
	xsltproc -o $@ $(STYLESHEETS_DIR)/xhtml/docbook.xsl $<

$(NAME).fo: $(NAME).xml
	xsltproc -o $@ $(STYLESHEETS_DIR)/fo/docbook.xsl $<

$(NAME).pdf: $(NAME).fo
	fop -pdf $@ -fo $<

$(SLIDES): $(NAME).otl
	OTL slidy <$< >$@
	if [ -n "$(SLIDES_STYLESHEET)" ]; then sed -i 's|</head>|\n<link href="$(SLIDES_STYLESHEET)" type="text/css" rel="stylesheet" />\n</head>|' $@; fi

$(SLIDES_DIST): $(SLIDES) $(SLIDES_STYLESHEET) splice.sed
	sed -f splice.sed $< >$@

clean:
	rm -rf $(NAME).xml $(NAME).html $(SLIDES) $(NAME).fo $(NAME).pdf $(SLIDES_DIST) dist
