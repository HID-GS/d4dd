#!/bin/bash

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -f ~/.ssh/id_ed25519 -N '' -t ed25519
fi