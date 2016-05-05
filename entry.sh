#!/bin/bash

user="builder"

su "$user" -c "/home/$user/start.sh $@"

