enclave_image = output/enclave.eif
docker_tag = rdesktop:latest
nitriding = nitriding/cmd/nitriding

.PHONY: all
all: $(enclave_image)

$(nitriding): nitriding/*
	make -C nitriding/cmd/ nitriding

.PHONY: docker_image
docker_image: Dockerfile
	docker build -t $(docker_tag) .

$(enclave_image): Dockerfile build-eif.sh
	./build-eif.sh $(docker_tag)
