#!/bin/bash

JMETER_VERSION=${JMETER_VERSION:-"5.5"}

# Example build line
docker build  --build-arg JMETER_VERSION=${JMETER_VERSION} -t "justb4/jmeter:${JMETER_VERSION}" .
