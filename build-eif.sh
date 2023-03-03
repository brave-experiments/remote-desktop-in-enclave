#!/bin/bash

tmp_dockerfile="Dockerfile.eif"
eif_file="enclave.eif"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DOCKER_IMAGE_TAG"
    exit 1
fi
docker_image_tag="$1"

cat > "$tmp_dockerfile" <<EOF
FROM public.ecr.aws/amazonlinux/amazonlinux:2

# See:
# https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave-cli-install.html#install-cli
RUN amazon-linux-extras install aws-nitro-enclaves-cli
RUN yum install aws-nitro-enclaves-cli-devel -y
RUN nitro-cli -V

# Now turn the local Docker image into an Enclave Image File (EIF).
CMD ["/bin/bash", "-c", \
     "nitro-cli build-enclave --docker-uri $docker_image_tag --output-file /output/$eif_file 2>/dev/null"]
EOF

# Build docker image that will compile our eif.
builder_image=$(docker build --no-cache --quiet -f "$tmp_dockerfile" . | cut -d ':' -f 2)

# Now run docker image.  The eif image will be in the output/ directory.
docker run \
    -ti \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(pwd)"/output:/output:rw \
    "$builder_image"

rm -f "$tmp_dockerfile"
