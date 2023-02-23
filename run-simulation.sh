#!/usr/bin/env sh
robin --output-dir ./out \
      --batcmd="batsim -p ./cluster_energy_128.xml --mmax-workload -w ./workload.json -e ./out/out -E" \
      --schedcmd="batsched -v sleeper --variant_options '{\"pstate_compute\": 0, \"pstate_sleep\": 13}'"
