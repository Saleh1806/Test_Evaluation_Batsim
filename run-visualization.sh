#!/usr/bin/env bash
./plot_energy_info.py \
  --gantt --power --ru \
  --names example \
  --off 13 --switchon 15 --switchoff 14 \
  --jobsCSV out/out_jobs.csv \
  --energyCSV out/out_consumed_energy.csv \
  --mstatesCSV out/out_machine_states.csv \
  #--pstatesCSV out/out_pstate_changes.csv
