# Consistently use the Python VENV
.ONESHELL:

SRC_DIR := ./src
BUILD_DIR := ./build

DIAGRAMS_PY_SRCS := $(shell find $(SRC_DIR) -wholename './src/diagrams/**.py')
# DIAGRAMS_PY_PNGS := $(DIAGRAMS_PY_SRCS:%=$(subst $(SRC_DIR),$(BUILD_DIR),$(basename %).png))
DIAGRAMS_PY_PNGS := $(subst $(SRC_DIR)/diagrams,$(BUILD_DIR),$(DIAGRAMS_PY_SRCS:%.py=%.png))
# DIAGRAMS_PY_PNGS := $(DIAGRAMS_PY_SRCS:%=$(basename %))

.PHONY: build
build: $(DIAGRAMS_PY_PNGS)

$(BUILD_DIR)/%.png: src/diagrams/%.py venv
	$(MKDIR_P) $(dir $@)
	BUILD_DIR=$(BUILD_DIR) $(VENV)/python3 -m $(basename $(subst /,.,$<))

.PHONY: clean
clean: clean-build clean-venv clean-pycache

.PHONY: clean-build
clean-build:
	rm -rf $(BUILD_DIR)

.PHONY: clean-pycache
clean-pycache:
	rm -rf **/__pycache__

MKDIR_P ?= mkdir -p


# From https://github.com/sio/Makefile.venv - thanks Sio!
include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2023.04.17/Makefile.venv"
	echo "fb48375ed1fd19e41e0cdcf51a4a0c6d1010dfe03b672ffc4c26a91878544f82 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv
