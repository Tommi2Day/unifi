#!/bin/bash
VERSION=5.10.12
REPO=unifi-5.10
#REPO=stable
VMNAME=${1:-unifi5}
if [ -r Dockerfile.$VMNAME ]; then
	DOCKER_USER=${DOCKER_USER:-tommi2day}
	#build the container
	docker stop $VMNAME 
	docker rm $VMNAME 
	docker build --no-cache --build-arg REPO=$REPO -t $DOCKER_USER/$VMNAME:$VERSION -f Dockerfile.$VMNAME . |tee build.log 
	IMAGE=$(awk  '/^Successfully built/ {print $3}' build.log)
	if [ -n "$IMAGE" ]; then
		docker tag $IMAGE $DOCKER_USER/$VMNAME:latest
	fi
else 
	echo "Usage: $0 VMNAME #Dockerfile.VMNAME must exists"
fi
