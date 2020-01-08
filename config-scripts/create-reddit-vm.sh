#!/bin/bash
gcloud compute instances create reddit-full \
--image-family=reddit-full \
--zone=europe-west1-b \
--tags=puma-server \
--machine-type=f1-micro \
