VERSION:=0.2

FILES:=build/pack.png build/pack.mcmeta build/fabric.mod.json
DP_OUTPUT:=lunar_origins_wopol_v$(VERSION).zip
JAR_OUTPUT:=lunar_origins_wopol_v$(VERSION).jar
YAML_FILES:=$(shell fd -eyaml . src/data)
JSON_FILES:=$(YAML_FILES:src/data/%.yaml=build/data/%.json)

SRC_DIRS:=$(shell fd -t dir . src/)
BUILD_DIRS:=$(SRC_DIRS:src/%=build/%)

FLAGS:=

$(JSON_FILES): $(BUILD_DIRS)

$(DP_OUTPUT): $(BUILD_DIRS) $(FILES) $(JSON_FILES)
	mkdir -p datapack_bin
	pushd build && \
	7z a -tzip ../datapack_bin/$(DP_OUTPUT) '*' && \
	popd

$(JAR_OUTPUT): $(BUILD_DIRS) $(FILES) $(JSON_FILES)
	mkdir -p fabric_bin
	pushd build && \
	7z a -tzip ../fabric_bin/$(JAR_OUTPUT) '*' && \
	popd

build/data/%.json: src/data/%.yaml
	./yaml2json.py $< -o $@ $(FLAGS)

build:
	mkdir build

$(BUILD_DIRS):
	mkdir -p $@

build/pack.png: src/pack.png build
	cp $< $@

build/pack.mcmeta: src/pack.mcmeta.yaml build
	./yaml2json.py $< -o $@ $(FLAGS)

build/fabric.mod.json: src/fabric.mod.yaml build
	./yaml2json.py $< -o $@ $(FLAGS)


.PHONY: clean datapack jar json

clean:
	-rm -r build

datapack: $(DP_OUTPUT)
jar: $(JAR_OUTPUT)
json: $(FILES) $(JSON_FILES)
