build:
	rm -rf *.iso
	docker build -f Dockerfile -t live-ros-builder .

iso-ros1: build
	docker run --rm -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION live-ros-builder /builder/build.sh ros1

iso-ros2: build
	docker run --rm -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION live-ros-builder /builder/build.sh ros2

iso-all: build
	docker run --rm -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION live-ros-builder /builder/build.sh all