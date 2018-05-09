SHELL:=/bin/bash

SRC_PACKAGE_NAME=bibtex2rfc
SRC_HOMEPAGE=https://github.com/jordanauge/bibtex2rfc
MAINTAINER=Jordan Augé <jordan.auge@free.fr>
PACKAGE_NAME=bibtex2rfc
VERSION=0.1
DEPENDS=python-bibtex
DESCRIPTION=Convert bibtex citations into bibxml references for use in Internet Drafts and RFCs.

all:
	@echo "Supported targets:"
	@echo "    deb: Build the bibtex2rfc debian package providing bibxml and bibmd"

deb:
	@rm -Rf $(PACKAGE_NAME)
	@mkdir -p $(PACKAGE_NAME)/DEBIAN
#	@echo "Source: $(SRC_PACKAGE_NAME)" > $(PACKAGE_NAME)/DEBIAN/control
#	@echo "Homepage: $(SRC_HOMEPAGE)" >> $(PACKAGE_NAME)/DEBIAN/control
#	@echo "" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Package: $(PACKAGE_NAME)" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Architecture: all" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Maintainer: $(MAINTAINER)" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Priority: optional" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Depends: $(DEPENDS)" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Version: $(VERSION)" >> $(PACKAGE_NAME)/DEBIAN/control
	@echo "Description: $(DESCRIPTION)" >> $(PACKAGE_NAME)/DEBIAN/control
	@mkdir -p $(PACKAGE_NAME)/usr/bin
	@cp bibxml.py $(PACKAGE_NAME)/usr/bin/bibxml
	@chmod 700 $(PACKAGE_NAME)/usr/bin/bibxml
	@cp bibmd.py $(PACKAGE_NAME)/usr/bin/bibmd
	@chmod 700 $(PACKAGE_NAME)/usr/bin/bibmd
	@cp bibtex.py $(PACKAGE_NAME)/usr/bin
	@chmod 700 $(PACKAGE_NAME)/usr/bin/bibtex.py
	@dpkg-deb --build $(PACKAGE_NAME)
	@rm -Rf $(PACKAGE_NAME)
