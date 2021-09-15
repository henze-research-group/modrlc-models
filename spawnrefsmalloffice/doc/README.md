# Spawn DOE Reference Small Office Building

This model is a Spawn replica of the DOE Reference Small Office Building. All systems, setpoints and schedules are replicated from the corresponding EnergyPlus model. ASHRAE Guideline 36 has been implemented where applicable using Modelica Building Library's components. 

## Envelope

TODO

## Air handling unit

This model implements ASHRAE Baseline System 3 AHUs, which are rooftop, packaged single-zone AHUs. A total of 5 of these AHUs are present in the model, and they are composed of an outside air damper without economizer, a constant air volume fan, a gas-fired modulating heating coil and a single-speed direct expansion cooling coil. A schematic of the system is shown in Figure 1 below.

TODO insert image in /figures folder

Figure 1: Schematic of the ASHRAE Baseline System 3 AHU implemented in this model.

## Built-in rule-based controller

The model implements a rule-based controller which follows ASHRAE Guideline 36 (2018). The GL-36 rules that are implemented here are described in Table 1. The low-level control loops are described in Table 2. 

The control loops are active whenever they are not being overridden by an external controller. This means that setting a control's `_activate` flag to 1 deactivates the rule-based control loop for that actuator, while setting the `_activate` flag to 0 releases the control point which therefore follows the rules described below.

TODO convert GL-36 table from the anchor paper here

TODO convert control loops table from the anchor paper here

## Inputs

This section presents a list of tags that can be used in an external controller script for overriding a control signal. To override a control signal, set the `_activate` flag to 1, and set the `_u` value to what you want it to be. To release the signal, set `_activate` to 0. 

### Low-level heating coil control:

The heating coil can be controlled directly by setting its load fraction (0% to 100%). 

| Control point                         | Description                       | Min   | Max   ||
|---------------------------------------|-----------------------------------|-------|-------|-|
|PSZACcontroller_oveHeaCor_u            |Core zone heating coil override    |  0    |  1    |%|
|PSZACcontroller_oveHeaCor_activate     |Activation for Core zone heating coil override|0|1|Bool|
|PSZACcontroller_oveHeaPer1_u|Perimeter zone 1 heating coil override|0|1|%|
|PSZACcontroller_oveHeaPer1_activate|Activation for Perimeter zone 1 heating coil override|0|1|Bool|
|PSZACcontroller_oveHeaPer2_u|Perimeter zone 2 heating coil override|0|1|%|
|PSZACcontroller_oveHeaPer2_activate|Activation for Perimeter zone 2 heating coil override|0|1|Bool|
|PSZACcontroller_oveHeaPer3_u|Perimeter zone 3 heating coil override|0|1|%|
|PSZACcontroller_oveHeaPer3_activate|Activation for Perimeter zone 3 heating coil override|0|1|Bool|
|PSZACcontroller_oveHeaPer4_u|Perimeter zone 4 heating coil override|0|1|%|
|PSZACcontroller_oveHeaPer4_activate|Activation for Perimeter zone 4 heating coil override|0|1|Bool|

### Low-level cooling coil control:

The single-speed DX cooling coil has an On/Off control signal.

| Control point                         | Description                       | Off   | On   ||
|---------------------------------------|-----------------------------------|-------|-------|-|
|PSZACcontroller_oveCooCor_u            |Core zone cooling coil override    |  0    |  1    |Bool|
|PSZACcontroller_oveCooCor_activate     |Activation for Core zone cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer1_u|Perimeter zone 1 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer1_activate|Activation for Perimeter zone 1 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer2_u|Perimeter zone 2 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer2_activate|Activation for Perimeter zone 2 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer3_u|Perimeter zone 3 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer3_activate|Activation for Perimeter zone 3 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer4_u|Perimeter zone 4 cooling coil override|0|1|Bool|
|PSZACcontroller_oveCooPer4_activate|Activation for Perimeter zone 4 cooling coil override|0|1|Bool|

### Low-level damper control:

The damper controls the volumetric flow rate of outside air.

| Control point                         | Description                       | Min   | Max   |
|---------------------------------------|-----------------------------------|-------|-------|
|PSZACcontroller_oveDamCor_u            |Core zone outside air volumetric flow rate override    |  0    |  0.5    |
|PSZACcontroller_oveDamCor_activate     |Activation for Core zone outside air volumetric flow rate override|0|1|
|PSZACcontroller_oveDamP1_u|Perimeter zone 1 outside air volumetric flow rate override|0|0.5
|PSZACcontroller_oveDamP1_activate|Activation for Perimeter zone 1 outside air volumetric flow rate override|0|1
|PSZACcontroller_oveDamP2_u|Perimeter zone 2 outside air volumetric flow rate override|0|0.5
|PSZACcontroller_oveDamP2_activate|Activation for Perimeter zone 2 outside air volumetric flow rate override|0|1
|PSZACcontroller_oveDamP3_u|Perimeter zone 3 outside air volumetric flow rate override|0|0.5
|PSZACcontroller_oveDamP3_activate|Activation for Perimeter zone 3 outside air volumetric flow rate override|0|1
|PSZACcontroller_oveDamP4_u|Perimeter zone 4 outside air volumetric flow rate override|0|0.5
|PSZACcontroller_oveDamP4_activate|Activation for Perimeter zone 4 outside air volumetric flow rate override|0|1

### Heating setpoint control:

This signal overrides the supervisory heating setpoint. The built-in rule-base controller will track that setpoint.

| Control point                         | Description                       | Min   | Max   | |
|---------------------------------------|-----------------------------------|-------|-------|--|
|PSZACcontroller_oveHeaStpCor_u            |Core zone heating setpoint override    |  250   |  330    |K|
|PSZACcontroller_oveHeaStpCor_activate     |Activation for Core zone heating setpoint override|0|1|Bool|
|PSZACcontroller_oveHeaStpPer1_u|Perimeter zone 1 heating setpoint override|250|330|K|
|PSZACcontroller_oveHeaStpPer1_activate|Activation for Perimeter zone 1 heating setpoint override|0|1|Bool|
|PSZACcontroller_oveHeaStpPer2_u|Perimeter zone 2 heating setpoint override|250|330|K|
|PSZACcontroller_oveHeaStpPer2_activate|Activation for Perimeter zone 2 heating setpoint override|0|1|Bool|
|PSZACcontroller_oveHeaStpPer3_u|Perimeter zone 3 heating setpoint override|250|330|K|
|PSZACcontroller_oveHeaStpPer3_activate|Activation for Perimeter zone 3 heating setpoint override|0|1|Bool|
|PSZACcontroller_oveHeaStpPer4_u|Perimeter zone 4 heating setpoint override|250|330|K|
|PSZACcontroller_oveHeaStpPer4_activate|Activation for Perimeter zone 4 heating setpoint override|0|1|Bool|



### Cooling setpoint control:

This signal overrides the supervisory cooling setpoint. The built-in rule-base controller will track that setpoint.

| Control point                         | Description                       | Min   | Max   | |
|---------------------------------------|-----------------------------------|-------|-------|--|
|PSZACcontroller_oveCooStpCor_u            |Core zone cooling setpoint override    |  250   |  330    |K|
|PSZACcontroller_oveCooStpCor_activate     |Activation for Core zone cooling setpoint override|0|1|Bool|
|PSZACcontroller_oveCooStpPer1_u|Perimeter zone 1 cooling setpoint override|250|330|K|
|PSZACcontroller_oveCooStpPer1_activate|Activation for Perimeter zone 1 cooling setpoint override|0|1|Bool|
|PSZACcontroller_oveCooStpPer2_u|Perimeter zone 2 cooling setpoint override|250|330|K|
|PSZACcontroller_oveCooStpPer2_activate|Activation for Perimeter zone 2 cooling setpoint override|0|1|Bool|
|PSZACcontroller_oveCooStpPer3_u|Perimeter zone 3 cooling setpoint override|250|330|K|
|PSZACcontroller_oveCooStpPer3_activate|Activation for Perimeter zone 3 cooling setpoint override|0|1|Bool|
|PSZACcontroller_oveCooStpPer4_u|Perimeter zone 4 cooling setpoint override|250|330|K|
|PSZACcontroller_oveCooStpPer4_activate|Activation for Perimeter zone 4 cooling setpoint override|0|1|Bool|

### Demand limit level:

This supervisory control point will set a demand limit level, and the built-in rule-based controller will limit its demand level by following ASHRAE GL-36.

| Control point                         | Description                       | Min   | Max   | |
|---------------------------------------|-----------------------------------|-------|-------|--|
|PSZACcontroller_oveDemandLimitLevel_u            |Demand limit level   |  0   |  5    |Level|
|PSZACcontroller_oveDemandLimitLevel_activate     |Activation for DL level override|0|1|Bool|


## Outputs:

This section presents the sensors available in the model. In the ACTB, all the sensors are available in the output of the `step` function of the API. For example, in Python, the `step` function returns a dict that contains all the sensor readings. Calling dict['sensor_tag'] returns the reading for the sensor named `sensor_tag`.

### Temperatures:

|Sensor|Description|Unit|
|-|-|-|
|senTemRoom_y|Core temperature| K|
|senTemRoom1_y|Perimeter zone 1 temperature| K|
|senTemRoom2_y|Perimeter zone 2 temperature| K|
|senTemRoom3_y|Perimeter zone 3 temperature| K|
|senTemRoom4_y|Perimeter zone 4 temperature| K|

### Total AHU power demand:

|Sensor|Description|Unit|
|-|-|-|
|senPowCor_y|Core AHU Power demand|W|
|senPowPer1_y|Perimeter zone 1 AHU Power demand|W|
|senPowPer2_y|Perimeter zone 2 AHU Power demand|W|
|senPowPer3_y|Perimeter zone 3 AHU Power demand|W|
|senPowPer4_y|Perimeter zone 4 AHU Power demand|W|

### Heating coil power demand *(note: must apply 0.8 efficiency)*:

|Sensor|Description|Unit|
|-|-|-|
|senHeaPow_y|Core Heating Coil Power|W|
|senHeaPow1_y|P1 Heating Coil Power|W|
|senHeaPow2_y|P2 Heating Coil Power|W|
|senHeaPow3_y|P3 Heating Coil Power|W|
|senHeaPow4_y|P4 Heating Coil Power|W|

### Cooling coil power demand:

|Sensor|Description|Unit|
|-|-|-|
|senCCPow_y|Core cooling Coil Power|W|
|senCCPow1_y|P1 cooling Coil Power|W|
|senCCPow2_y|P2 cooling Coil Power|W|
|senCCPow3_y|P3 cooling Coil Power|W|
|senCCPow4_y|P4 cooling Coil Power|W|

### Fan power demand:

|Sensor|Description|Unit|
|-|-|-|
|senFanPow_y|Core fan Power|W|
|senFanPow1_y|P1 fan Power|W|
|senFanPow2_y|P2 fan Power|W|
|senFanPow3_y|P3 fan Power|W|
|senFanPow4_y|P4 fan Power|W|

### Other:

|Sensor|Description|Unit|
|-|-|-|
|senHouDec_y|Hour of the day|hours (0.0 to 23.9)|
|senDay_y|Day of the week|day (1 to 7)|
|senTemOA_y|OA Temperature|K|
