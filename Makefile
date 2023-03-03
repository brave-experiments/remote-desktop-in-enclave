enclave_image = output/enclave.eif
nitriding = nitriding/cmd/nitriding
docker_tag = rdesktop:latest

.PHONY: all
all: $(enclave_image)

.PHONY: submodule
submodule:
	git submodule init
	git submodule update

$(nitriding): submodule
	make -C nitriding/cmd/ nitriding

.PHONY: docker_image
docker_image: $(nitriding) Dockerfile
	docker build -t $(docker_tag) .

$(enclave_image): docker_image Dockerfile build-eif.sh
	./build-eif.sh $(docker_tag)

.PHONY: clean
clean:
	rm -f $(nitriding) $(enclave_image)
	-docker image rm $(docker_tag)
