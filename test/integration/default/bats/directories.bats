#!/usr/bin/env bats

@test "/assets diretory is found" {
  run ls /assets
  [ "$status" -eq 0 ]
}