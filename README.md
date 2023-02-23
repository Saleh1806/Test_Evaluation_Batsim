# Batsim simulation & visualization example

## Description of files in this repo
- [flake.nix](flake.nix) defines the software environments for this tutorial (`simulation` and `vizualization`)  
  [flake.lock](flake.lock) contains a dump of the exact software environment used (git commits of inputs)
- [cluster_energy_128.xml](cluster_energy_128.xml) and [workload.json](workload.json) are Batsim simulation example inputs (platform and workload)
- [run-simulation.sh](run-simulation.sh) runs a Batsim simulation
- [run-visualization.sh](run-visualization.sh) runs an interactive visualization of Batsim outputs  
  This script calls [plot_energy_info.py](plot_energy_info.py) internally

## Prerequisites
This tutorials expects the following.

- [Nix](https://nixos.org) should be installed on the machine you use ([official tuto](https://nixos.org/download.html#download-nix))
- Nix flakes should be enabled in Nix's configuration ([official tuto](https://nixos.wiki/wiki/Flakes#Permanent))

As I write these lines, the following commands should install Nix and configure it to enable flakes.

```sh
# Install Nix. Should be executed as a normal used that can use sudo.
curl -L https://nixos.org/nix/install | bash

# Load Nix in your shell
source ~/.nix-profile/etc/profile.d/nix.sh

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## Run the simulation
This is done by calling the `run-simulation.sh` script from the `simulation` environment.

```sh
# First, enter the simulation environment
nix develop .#simulation

# Then, inside the shell created by the previous command, run the simulation
./run-simulation.sh
```

## Run the interactive visualization
This is done by calling the `run-visualization.sh` script from the `visualization` environment.

```sh
# First, enter the visualization environment
nix develop .#visualization

# Then, inside the shell created by the previous command, run the visualization
./run-visualization.sh
```
