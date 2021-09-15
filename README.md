# MODRLC Models

## Purpose

This repository hosts models used in the Advanced Controller Test Bed (ACTB), a virtual test bed for developing and evaluating advanced controllers, such as model predictive control (MPC) or reinforcement learning control (RLC).
The ACTB uses Spawn of EnergyPlus, or Spawn, high-fidelity building models. The building envelope is simulated in EnergyPlus, while building systems are simulated using a Modelica solver. The models hosted here are resources intended to be used within the ACTB and will not work on other platforms if they are not modified first.

## Contents

At the moment, two U.S. Department of Energy's (DOE) Reference Commercial building models are hosted:

1. A single floor, 5 zone small office building equipped with ASHRAE Baseline System 3 air handling units (AHU), which are constant volume, packaged single-zone AHUs;
2. A 3-floors, 15 zone medium office building equipped with multi-zone variable air volume AHUs (in development)

This list will be updated as new models become available.
Planned models:

1. A DOE Reference large office building

## Model features

Documentation for each model can be found in the `docs` folder, found at the root of the folder containing said models. The documentation describes the model properties (envelope and equipment) as well as the available sensors and control override points, used in the ACTB.

## Acknowledgements

This work is developed under the umbrella of the Multi-Objective Deep Reinforcement Learning project, led by PI Andrey Bernstein of the National Renewable Energy Laboratory and co-led by the Colorado University Boulder. The ACTB and the models presented here are developed at the Colorado University Boulder, by Prof. Gregor Henze, Dr. Thibault Marzullo, and Ph.D. candidates Nicholas Long and Sourav Dey. This work is funded by the U.S. Department of Energy.