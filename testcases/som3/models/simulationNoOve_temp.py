# -*- coding: utf-8 -*-
"""
This module manages the simulation of SOM3 in BOPTEST. It initializes,
steps and computes controls for the HVAC system.
The testcase docker container must be running before launching this
script.
"""

# GENERAL PACKAGE IMPORT
# ----------------------
import requests
import numpy as np
import json, collections
from matplotlib import pyplot as plt
import csv
import time

def run(plot=True, customized_kpi_config=None):
    '''Run test case.

    Parameters
    ----------
    plot : bool, optional
        True to plot timeseries results.
        Default is False.
    customized_kpi_config : string, optional
        The path of the json file which contains the customized kpi information.
        Default is None.

    Returns
    -------
    kpi : dict
        Dictionary of core KPI names and values.
        {kpi_name : value}
    res : dict
        Dictionary of trajectories of inputs and outputs.
    customizedkpis_result: dict
        Dictionary of tracked custom KPI calculations.
        Empty if no customized KPI calculations defined.

    '''
    
    # SETUP TEST CASE
    # ---------------
    
    
    # Set URL for testcase
    
    url = 'http://0.0.0.0:5000'
    
    # Set simulation parameters
    
    length = 7 * 24 * 3600
    step = 240

    simStartTime = 0 * 3600
    warmupPeriod = 24 * 3600

    # ---------------

    start = time.time()

    # GET TEST INFORMATION
    # --------------------

    print('\nTEST CASE INFORMATION\n---------------------')
    
    # Test case name
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))
    
    # Available inputs
    inputs = requests.get('{0}/inputs'.format(url)).json()
    print('Control Inputs:\t\t\t{0}'.format(inputs))
    
    # Available measurements
    measurements = requests.get('{0}/measurements'.format(url)).json()
    print('Measurements:\t\t\t{0}'.format(measurements))
    
    # Default simulation step
    step_def = requests.get('{0}/step'.format(url)).json()
    print('Default Simulation Step:\t{0}'.format(step_def))
    # --------------------

    # Define customized KPI if any

    customizedkpis = []  # Initialize customzied kpi calculation list

    # --------------------

    # RUN TEST CASE
    # -------------
    # Reset test case

    print('Initializing the simulation.')
    res = requests.put('{0}/initialize'.format(url), data={'start_time': simStartTime, 'warmup_period': warmupPeriod})
    if res:
        print('Successfully initialized the simulation')

    # Set simulation step
    print('Setting simulation step to {0}.'.format(step))
    res = requests.put('{0}/step'.format(url), data={'step': step})
    print('\nRunning test case...')
    
    # Initialize u
    u = initializeControls()
    print('\nRunning controller script...')
    
    # Simulation Loop

    damControls, fanControls, vent = [0, 0, 0, 0, 0]

    for i in range(int(length / step)):
        # Advance simulation
        y = requests.post('{0}/advance'.format(url), data=u).json()
        # Compute next control signal
        u, damControls, fanControls, vent = computeControls(y, damControls, fanControls, vent, step)

    print('\nTest case complete.')
    # -------------

    # POST PROCESS RESULTS
    # --------------------
    # Get result data

    res = requests.get('{0}/results'.format(url)).json()
    time = [x / 3600 / 24 for x in res['y']['time']]  # convert s --> hr
    loSet = [21.0 if (res['y']['senDay_y'][i] <= 5 and 8 <= res['y']['senHou_y'][i] < 18) or (
                res['y']['senDay_y'][i] == 6 and 8 <= res['y']['senHou_y'][i] < 18) else 15.6 for i in range(len(res['y']['time']))]
    hiSet = [24.0 if (res['y']['senDay_y'][i] <= 5 and 8 <= res['y']['senHou_y'][i] < 18) or (
                res['y']['senDay_y'][i] == 6 and 8 <= res['y']['senHou_y'][i] < 18) else 26.7 for i in range(len(res['y']['time']))]
    TZone = [x - 273.15 for x in res['y']['senTRoom_y']]  # convert K --> C
    TZone1 = [x - 273.15 for x in res['y']['senTRoom1_y']]  # convert K --> C
    TZone2 = [x - 273.15 for x in res['y']['senTRoom2_y']]  # convert K --> C
    TZone3 = [x - 273.15 for x in res['y']['senTRoom3_y']]  # convert K --> C
    TZone4 = [x - 273.15 for x in res['y']['senTRoom4_y']]  # convert K --> C
    TOA = [x - 273.15 for x in res['y']['senTemOA_y']]  # convert K --> C
    PHeat = res['y']['senHeaPow_y']
    PHeat1 = res['y']['senHeaPow1_y']
    PHeat2 = res['y']['senHeaPow2_y']
    PHeat3 = res['y']['senHeaPow3_y']
    PHeat4 = res['y']['senHeaPow4_y']
    PCool = res['y']['senCCPow_y']
    PCool1 = res['y']['senCCPow1_y']
    PCool2 = res['y']['senCCPow2_y']
    PCool3 = res['y']['senCCPow3_y']
    PCool4 = res['y']['senCCPow4_y']
    PFan = res['y']['senFanPow_y']
    PFan1 = res['y']['senFanPow1_y']
    PFan2 = res['y']['senFanPow2_y']
    PFan3 = res['y']['senFanPow3_y']
    PFan4 = res['y']['senFanPow4_y']

    # Print KPIs

    kpi = requests.get('{0}/kpi'.format(url)).json()
    print('\nKPI RESULTS \n-----------')
    for key in kpi.keys():
        if key == 'tdis_tot':
            unit = 'Kh'
        if key == 'idis_tot':
            unit = 'ppmh'
        elif key == 'ener_tot':
            unit = 'kWh'
        elif key == 'cost_tot':
            unit = 'euro or $'
        elif key == 'emis_tot':
            unit = 'kg CO2'
        elif key == 'time_rat':
            unit = ''
        else:
            unit = ''
        print('{0}: {1} {2}'.format(key, kpi[key], unit))

    # Plot results

    results = [time, loSet, hiSet, TZone, TZone1, TZone2, TZone3, TZone4, TOA, PHeat, PHeat1, PHeat2, PHeat3, PHeat4,
               PCool, PCool1, PCool2, PCool3, PCool4, PFan, PFan1, PFan2, PFan3, PFan4]
    results = list(map(list, zip(*results)))
    with open('wrapped_results.csv', mode='w') as resultsFile:
        resultsWriter = csv.writer(resultsFile, delimiter=',')
        for line in range(len(results)):
            resultsWriter.writerow(results[line])

    if plot:
        plt.figure(1)
        plt.title('Core Zone Temperature')
        plt.plot(time, TZone, label='Zone temperature')
        plt.plot(time, loSet, '--', label='Lower comfort bound')
        plt.plot(time, hiSet, '--', label='Upper comfort bound')
        plt.ylabel('Temperature [C]')
        plt.xlabel('Time [days]')
        plt.legend()

        plt.figure(2)
        plt.title('Perimeter Zone 1 Temperature')
        plt.plot(time, TZone1)
        plt.plot(time, loSet, '--')
        plt.plot(time, hiSet, '--')
        plt.ylabel('Temperature [C]')
        plt.xlabel('Time [days]')

        plt.figure(3)
        plt.title('Perimeter Zone 2 Temperature')
        plt.plot(time, TZone2)
        plt.plot(time, loSet, '--')
        plt.plot(time, hiSet, '--')
        plt.ylabel('Temperature [C]')
        plt.xlabel('Time [days]')

        plt.figure(4)
        plt.title('Perimeter Zone 3 Temperature')
        plt.plot(time, TZone3)
        plt.plot(time, loSet, '--')
        plt.plot(time, hiSet, '--')
        plt.ylabel('Temperature [C]')
        plt.xlabel('Time [days]')

        plt.figure(5)
        plt.title('Perimeter Zone 4 Temperature')
        plt.plot(time, TZone4)
        plt.plot(time, loSet, '--')
        plt.plot(time, hiSet, '--')
        plt.ylabel('Temperature [C]')
        plt.xlabel('Time [days]')

        plt.figure(6)
        plt.title('Core Zone Heating Coil Power Demand')
        plt.plot(time, PHeat)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(7)
        plt.title('Perimeter Zone 1 Heating Coil Power Demand')
        plt.plot(time, PHeat1)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(8)
        plt.title('Perimeter Zone 2 Heating Coil Power Demand')
        plt.plot(time, PHeat2)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(9)
        plt.title('Perimeter Zone 3 Heating Coil Power Demand')
        plt.plot(time, PHeat3)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(10)
        plt.title('Perimeter Zone 4 Heating Coil Power Demand')
        plt.plot(time, PHeat4)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(11)
        plt.title('Core Zone Cooling Coil Power Demand')
        plt.plot(time, PCool)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(12)
        plt.title('Perimeter Zone 1 Cooling Coil Power Demand')
        plt.plot(time, PCool1)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(13)
        plt.title('Perimeter Zone 2 Cooling Coil Power Demand')
        plt.plot(time, PCool2)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(14)
        plt.title('Perimeter Zone 3 Cooling Coil Power Demand')
        plt.plot(time, PCool3)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(15)
        plt.title('Perimeter Zone 4 Cooling Coil Power Demand')
        plt.plot(time, PCool4)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(16)
        plt.title('Core Zone Fan Power Demand')
        plt.plot(time, PFan)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(17)
        plt.title('Perimeter Zone 1 Fan Power Demand')
        plt.plot(time, PFan1)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(18)
        plt.title('Perimeter Zone 2 Fan Power Demand')
        plt.plot(time, PFan2)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(19)
        plt.title('Perimeter Zone 3 Fan Power Demand')
        plt.plot(time, PFan3)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')

        plt.figure(20)
        plt.title('Perimeter Zone 4 Fan Power Demand')
        plt.plot(time, PFan4)
        plt.ylabel('Power [W]')
        plt.xlabel('Time [days]')


        plt.show()
    # --------------------

    return res


def printStatus(start, timestep, i, j, ):
    ''' Prints a line that shows current simulated time, percentage
    of completion and elapsed time.

    Parameters
    ----------
    start : float
    	Simulation start time
    timestep : float
    	Current simulated time
    i : int
    	Current iteration step
    j : int
    	Total iteration steps
    Returns
    ----------
    Nothing
    '''
    import time
    elapsed = time.time() - start
    minutes, seconds = divmod(elapsed, 60)
    hours, minutes = divmod(minutes, 60)
    print('Time: {} seconds'.format(timestep), end="")
    print('   Elapsed time: %dh %dmin %dsec' % (hours, minutes, seconds), end="")
    print('   %.2f%% complete\r' % (100 * i / j), end="")

    return 1


def printActions(action, sensor, time, setpoint):
    ''' Prints a line that shows current simulated time, percentage
    of completion and elapsed time.

    Parameters
    ----------
    start : float
    	Simulation start time
    timestep : float
    	Current simulated time
    i : int
    	Current iteration step
    j : int
    	Total iteration steps
    Returns
    ----------
    Nothing
    '''

    print('HC_core: %.2f%%' % (action * 100), end="")
    print('   Core_temp: %.2f K' % (sensor), end="")
    print('   Time: %.2f hours' % (time / 3600), end="")
    print('   LoStp: %.2f K\r' % (setpoint), end="")

    return 1


def computeControls(y, damControls, fanControls, vent, step):
    '''Compute the control input from the measurement.

    Parameters
    ----------
    y : dict
        Contains the current values of the measurements.
        {<measurement_name>:<measurement_value>}
    pidHea : PID object
    	pidHea, pidHea1 through pidHea4 are the PID objects for the heating coil command

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    '''

    '''
    SOM3
    List of sensors:
    ---HVAC SENSORS
    senTRoom_y  		- Core zone room temperature sensor (K)
    senTRoom[1-4]_y		- Perimeter zone [1 to 4] room temperature sensor (K)
    senRH_y			- Core zone relative humidity
    senRH[1-4]_y		- Perimeter zone [1 to 4] relative humidity
    senHeaPow_y		- Core zone heating coil power demand (W)
    senHeaPow[1-4]_y		- Perimeter zone [1 to 4] heating coil power demand (W)
    senCCPow_y			- Core zone cooling coil power demand (W)
    senCCPow[1-4]_y		- Perimeter zone [1 to 4] cooling coil power demand (W)
    senFanPow_y		- Core zone fan power demand (W)
    senFanPow[1-4]_y		- Perimeter zone [1 to 4] fan power demand (W) 
    senFanVol_y		- Core zone fan volumetric flow rate (m3/s)
    senFanVol[1-4]_y		- Perimeter zone [1 to 4] fan volumetric flow rate (m3/s)
    senOAVol_y			- Core zone OA volumetric flow rate (m3/s)
    senOAVol[1-4]_y 		- Perimeter zone [1 to 4] OA volumetric flow rate (m3/s)
    ---OTHER OUTPUTS
    senTemOA_y			- Outside air temperature, dry bulb, from weather file (K)
    senDay_y			- Day of the week (1 - Monday to 7 - Sunday)
    senHou_y			- Hour of the day (0-23 hours), only whole hours
    
    '''

    # Schedule #
    weekDayStart = 6.0
    weekDayEnd = 22.0
    saturdayStart = 6.0
    saturdayEnd = 18.0

    # Controller parameters
    lowerSetpointOccupied = 273.15 + 21
    upperSetpointOccupied = 273.15 + 24
    lowerSetpointNonOccupied = 273.15 + 15.6
    upperSetpointNonOccupied = 273.15 + 26.7

    minHR = 0.1
    maxHR = 0.9
    HRSet = 0.5

    minOANonOccupied = [0.080, 0.061, 0.036, 0.061, 0.036]
    minOAOccupied = [1.0, 1.0, 1.0, 1.0, 1.0]

    minVentilationOccupied = [0.448, 0.370, 0.360, 0.382, 0.352]
    minVentilationNonOccupied = [0.1, 0.1, 0.1, 0.1, 0.1]

    minCCOpeTemp = 275
    isOcc = False
    zones = 5

    # Compute setpoint

    if (y['senDay_y'] <= 5 and (weekDayStart <= y['senHou_y'] < weekDayEnd)) or (
            y['senDay_y'] == 6 and (saturdayStart <= y['senHou_y'] < saturdayEnd)):
        lowerSetpoint = lowerSetpointOccupied
        upperSetpoint = upperSetpointOccupied
        minOA = minOANonOccupied
        fanSetpoint = minVentilationOccupied
        isOcc = True
    else:
        lowerSetpoint = lowerSetpointNonOccupied
        upperSetpoint = upperSetpointNonOccupied
        minOA = minOANonOccupied
        fanSetpoint = minVentilationNonOccupied
        isOcc = False

    # Compute controls

    temperatures = [y['senTRoom_y'], y['senTRoom1_y'], y['senTRoom2_y'], y['senTRoom3_y'], y['senTRoom4_y']]
    RHs = [y['senRH_y'], [y['senRH1_y'], [y['senRH2_y'], [y['senRH3_y'], [y['senRH4_y']]
    
    for i in range(zones-1):
        HCControls[i], CCControls[i], fanSta[i] = rulebased(temperatures[i], RHs[i], lowerSetpoint, upperSetpoint, HRSet, cooSta, fanSta)

    # Dampers

    index = 0

    for dam in [y['senOAVol_y'], y['senOAVol1_y'], y['senOAVol2_y'], y['senOAVol3_y'], y['senOAVol4_y']]:
        damControls[index] = max(min(1, damControls[index] + 0.2 * (minOA[index] - dam)), minOA[index])
        index += 1

    # Fans
    index = 0
    
    for fan in [y['senFanVol_y'], y['senFanVol1_y'], y['senFanVol2_y'], y['senFanVol3_y'], y['senFanVol4_y']]:  
        if HCControls[index] == 0 and CCControls[index] == 0 and not isOcc:
            fanSta[index] = False
            fanSetpoint[index] = minVentilationNonOccupied[index]
        if isOcc or fanSta[index]:
            fanSetpoint[index] = minVentilationOccupied[index]
        fanControls[index] = max(min(1.5, fanControls[index] + 0.2 * (fanSetpoint[index] - fan)),
                                 minVentilationNonOccupied[index])
        index += 1

    print(
        "\nt_sim:%.2f hr\tstep:%.0f\tTOA:%.2f K\tDay:%.0f\n" % (y['time'] / 3600, step, y['senTemOA_y'], y['senDay_y']),
        end="")
    print("Lower setpoint: %.2f K\t\tUpper setpoint: %.2f K\n" % (lowerSetpoint, upperSetpoint), end="")
    print("\tCore\tP1\tP2\tP3\tP4\n", end="")
    print("Temps:\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n" % (
    y['senTRoom_y'], y['senTRoom1_y'], y['senTRoom2_y'], y['senTRoom3_y'], y['senTRoom4_y']), end="")
    print("RHs:\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\n" % (
    y['senRH_y'], y['senRH1_y'], y['senRH2_y'], y['senRH3_y'], y['senRH4_y']), end="")
    print("HPow:\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n" % (
    y['senHeaPow_y'], y['senHeaPow1_y'], y['senHeaPow2_y'], y['senHeaPow3_y'], y['senHeaPow4_y']), end="")
    print("HCom:\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n" % (oveHCSet, oveHCSet1, oveHCSet2, oveHCSet3, oveHCSet4), end="")
    print("CPow:\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n" % (
    y['senCCPow_y'], y['senCCPow1_y'], y['senCCPow2_y'], y['senCCPow3_y'], y['senCCPow4_y']), end="")
    print("CCom:\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n" % (oveCC, oveCC1, oveCC2, oveCC3, oveCC4), end="")
    print("FPow:\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n" % (
    y['senFanPow_y'], y['senFanPow1_y'], y['senFanPow2_y'], y['senFanPow3_y'], y['senFanPow4_y']), end="")
    print("FCom:\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n" % (
    fanControls[0], fanControls[1], fanControls[2], fanControls[3], fanControls[4]), end="")
    print("FVol:\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n" % (
    y['senFanVol_y'], y['senFanVol1_y'], y['senFanVol2_y'], y['senFanVol3_y'], y['senFanVol4_y']), end="")
    print("DVol:\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n" % (
    y['senOAVol_y'], y['senOAVol1_y'], y['senOAVol2_y'], y['senOAVol3_y'], y['senOAVol4_y']), end="")

    u = {'oveHCSet_u': HCControls[0],
         'oveHCSet_activate': 0,
         'oveHCSet1_u': HCControls[1],
         'oveHCSet1_activate': 0,
         'oveHCSet2_u': HCControls[2],
         'oveHCSet2_activate': 0,
         'oveHCSet3_u': HCControls[3],
         'oveHCSet3_activate': 0,
         'oveHCSet4_u': HCControls[4],
         'oveHCSet4_activate': 0,
         'oveCC_u': CCControls[0],
         'oveCC_activate': 0,
         'oveCC1_u': CCControls[1],
         'oveCC1_activate': 0,
         'oveCC2_u': CCControls[2],
         'oveCC2_activate': 0,
         'oveCC3_u': CCControls[3],
         'oveCC3_activate': 0,
         'oveCC4_u': CCControls[4],
         'oveCC4_activate': 0,
         'oveDSet_u': damControls[0],
         'oveDSet_activate': 0,
         'oveDSet1_u': damControls[1],
         'oveDSet1_activate': 0,
         'oveDSet2_u': damControls[2],
         'oveDSet2_activate': 0,
         'oveDSet3_u': damControls[3],
         'oveDSet3_activate': 0,
         'oveDSet4_u': damControls[4],
         'oveDSet4_activate': 0,
         'oveVFRSet_u': fanControls[0],
         'oveVFRSet_activate': 0,
         'oveVFRSet1_u': fanControls[1],
         'oveVFRSet1_activate': 0,
         'oveVFRSet2_u': fanControls[2],
         'oveVFRSet2_activate': 0,
         'oveVFRSet3_u': fanControls[3],
         'oveVFRSet3_activate': 0,
         'oveVFRSet4_u': fanControls[4],
         'oveVFRSet4_activate': 0}

    return u, damControls, fanControls, vent

def rulebased(temp, rh, lowsetp, uppsetp, rhSet cooSta, fanSta):
    
    ### Init
    heaSet = 0.0
    ### Thresholds ###    
    heaUp = 0.5
    heaLo = 3
    cooUp = 0.5
    cooLo = 1
    dehUp = 0.1
    dehLo = 0.2
    ####
    
    if temp <= lowsetp - heaLo:
        heaSet = 1.0
    elif lowsetp - 3.0 < temp <= lowsetp + heaUp:
        heaSet = -0.285 * temp + 1
    else:
        heaSet = 0.0
    if cooSta and ((temp < uppSetp - cooLo and rh < rhSet - dehLo) or temp < lowsetp):
        cooSta = False
    elif not cooSta and (temp > uppSetp + cooUp or rh > rhSet + dehUp):
        cooSta = True
    if not fanSta and (cooSta or heaSet >= 0.0):
        heaSet = 0.0
        cooSta = 0.0
        fanSta = True
            
    return(heaSet, cooSta, fanSta)

def initializeControls():
    '''Initialize the control input u.

    Parameters
    ----------
    None

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    '''

    u = {'oveHCSet_u': 0,
         'oveHCSet_activate': 0,
         'oveHCSet1_u': 0,
         'oveHCSet1_activate': 0,
         'oveHCSet2_u': 0,
         'oveHCSet2_activate': 0,
         'oveHCSet3_u': 0,
         'oveHCSet3_activate': 0,
         'oveHCSet4_u': 0,
         'oveHCSet4_activate': 0,
         'oveCC_u': 0,
         'oveCC_activate': 0,
         'oveCC1_u': 0,
         'oveCC1_activate': 0,
         'oveCC2_u': 0,
         'oveCC2_activate': 0,
         'oveCC3_u': 0,
         'oveCC3_activate': 0,
         'oveCC4_u': 0,
         'oveCC4_activate': 0,
         'oveDSet_u': 0,
         'oveDSet_activate': 0,
         'oveDSet1_u': 0,
         'oveDSet1_activate': 0,
         'oveDSet2_u': 0,
         'oveDSet2_activate': 0,
         'oveDSet3_u': 0,
         'oveDSet3_activate': 0,
         'oveDSet4_u': 0,
         'oveDSet4_activate': 0,
         'oveVFRSet_u': 0,
         'oveVFRSet_activate': 0,
         'oveVFRSet1_u': 0,
         'oveVFRSet1_activate': 0,
         'oveVFRSet2_u': 0,
         'oveVFRSet2_activate': 0,
         'oveVFRSet3_u': 0,
         'oveVFRSet3_activate': 0,
         'oveVFRSet4_u': 0,
         'oveVFRSet4_activate': 0}

    return u


if __name__ == "__main__":
    res = run()
