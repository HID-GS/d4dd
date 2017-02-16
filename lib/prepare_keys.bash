#!/bin/bash

ssh_type="ed25519"
if [ ! -f ~/.ssh/id_$ssh_type ]; then
  ssh-keygen -f ~/.ssh/id_$ssh_type -N '' -t $ssh_type
fi