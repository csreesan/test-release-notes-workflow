#!/bin/bash

# @ sign just suppress the echo of the command
# $$ is basically just passing $ to the shell
# if you want the shell to expand a variable, rather than having the makefile do it you need to escape $ by using $$
# cd - goes back to where you previously were

# sed = stream editor, has many commands but most people use s (substituion) sed s/day/night/ old >new changes "day" in the old file to night in the new file
# echo day | sed s/day/night/
# echo "day day bob day" | sed s/day/night/g
# -i = --in-place = in-place argument


CLI_NAME=ccloud
DOCS_BRANCH=main
VERSION=1.0.0
RELEASE_DIR=release-notes

.PHONY: release-notes
release-notes:
	@GO11MODULE=on go run -ldflags '-X main.cliName=ccloud' cmd/release-notes/main.go 



.PHONY: publish-release-notes
publish-release-notes: release-notes
	@TEMP_DIR=$$(mktemp -d)/docs || exit 1; \
		git clone git@github.com:confluentinc/docs.git $${TMP_DIR}; \
		cd $${TMP_DIR} || exit 1; \
		git fetch ; \
		git checkout -b cli-$(VERSION) origin/$(DOCS_BRANCH) || exit 1; \
		cd - || exit 1; \
		make publish-release-notes-internal BASE_DIR=$${TMP_DIR} CLI_NAME=ccloud || exit 1; \
		cd $${TMP_DIR} || exit 1; \
		git add . || exit 1; \
		git diff --cached --exit-code > /dev/null && echo "nothing to update" && exit 0; \
		git commit -m "new release notes for $(VERSION)" || exit 1; \
		git push origin cli-$(VERSION) || exit 1; \
		# hub pull-request -b $(DOCS_BRANCH) -m "new release notes for $(VERSION)" || exit 1; 
		cd - || exit 1; \
		rm -rf $${TMP_DIR}	

.PHONY: publish-release-notes-internal
publish-release-notes-internal:
ifndef BASE_DIR
	$(error BASE_DIR is not set)
endif 
ifeq (ccloud,$(CLI_NAME))
	$(eval RELEASE_DIR := release-notes)
endif
	rm $(BASE_DIR)/$(RELEASE_DIR)/*.rst
	cp release-notes/$(CLI_NAME)/*.rst $(BASE_DIR)/$(RELEASE_DIR)

.PHONY: clean-releases
clean-releases:
	rm release-notes/*/*.rst


no-dub:
	for i in a b c d; do echo $i; done

dub:
	for i in a b c d; do echo $$i; done
