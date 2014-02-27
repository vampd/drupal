#!/usr/bin/env bats

@test "/assets diretory is found" {
  run test -d /assets
  [ "$status" -eq 0 ]
}
