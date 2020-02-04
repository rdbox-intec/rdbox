#!/bin/sh

vagrant provision rdbox-vpn --provision-with serverspec
vagrant provision rdbox-master --provision-with serverspec
