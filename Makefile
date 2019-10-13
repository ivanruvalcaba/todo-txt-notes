#
# Filename: Makefile
# Author: Iván Ruvalcaba
# Contact: <ivanruvalcaba[at]disroot[dot]org>
# Created: 12 oct 2019 13:27:40
# Last Modified: 12 oct 2019 13:57:25
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PANDOC = pandoc
ASSETS_DIR = assets
DOCUMENT = index
DOCUMENT_AUTHOR = "Iván Ruvalcaba"
DOCUMENT_DATE = $(shell date --iso=seconds)
DOCUMENT_DESCRIPTION = "Todo.txt Notes"
DOCUMENT_KEYWORDS = "todo.txt, GTD"
DOCUMENT_LANGUAGE = es
DOCUMENT_MARKDOWN_FLAVOR = gfm
DOCUMENT_TEMPLATE = GitHub.html5
DOCUMENT_TITLE = "TODO.txt Notes"
DOCUMENT_TYPE = html5
FILTERS_DIR = plugins
PARTIALS_DIR = partials
PUBLIC_DIR = public_html

all: clean init build

init:
	mkdir -p ${PUBLIC_DIR}
	cp -r ${ASSETS_DIR}/. ${PUBLIC_DIR}

build:
	@echo "Converting markdown to ${DOCUMENT_TYPE}."
	$(PANDOC) docs/$(DOCUMENT).md \
		--from $(DOCUMENT_MARKDOWN_FLAVOR) \
		--to $(DOCUMENT_TYPE) \
		--output $(PUBLIC_DIR)/$(DOCUMENT).html \
		--template templates/$(DOCUMENT_TEMPLATE) \
		--metadata pagetitle=$(DOCUMENT_TITLE) \
		--metadata lang=$(DOCUMENT_LANGUAGE) \
		--metadata author-meta=$(DOCUMENT_AUTHOR) \
		--metadata date-meta=$(DOCUMENT_DATE) \
		--metadata description=$(DOCUMENT_DESCRIPTION) \
		--metadata keywords=$(DOCUMENT_KEYWORDS) \
		--include-in-header $(PARTIALS_DIR)/header.html \
		--include-after-body $(PARTIALS_DIR)/navbar.html \
		--include-after-body $(PARTIALS_DIR)/footer.html \
		--filter pandoc-include \
		--lua-filter $(FILTERS_DIR)/task-list/task-list.lua \
		--toc \
		--section-divs \
		--standalone

clean:
	rm -rf ${PUBLIC_DIR}
