#!/usr/bin/env zsh

DEBUG=true bundle exec rspec --only-failures 

if [ $? -eq 0 ]; then
    bundle exec rspec --profile
fi
