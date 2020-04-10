#!/bin/bash

cp /root/.config/gcloud/legacy_credentials/"$(gcloud auth list --format=json | jq -r .[0].account)"/adc.json /root/.config/gcloud/application_default_credentials.json