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
import time as _time
import os

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
    sudoPassword = 'toosmartfordah'
    
    print("TESTING: Stopping Docker container")
    command = 'bash stop.sh'
    p = os.system('echo %s|sudo -S %s' % (sudoPassword, command))
    _time.sleep(3)
    
    print("TESTING: Starting Docker container")
    command = 'bash start.sh'
    p = os.system('echo %s|sudo -S %s' % (sudoPassword, command))
    _time.sleep(5)
    
    # SETUP TEST CASE
    # ---------------
    # Set URL for testcase
    # url = 'http://127.0.0.1:5000'
    
    url = 'http://0.0.0.0:5000'
    
    # Set simulation parameters
    length = 1 * 1 * 3600

    step = 300

    simStartTime = 0 * 0 * 3600
    warmupPeriod = 0 * 1 * 3600

    # ---------------


    # GET TEST INFORMATION
    # --------------------

    print('\nTEST CASE INFORMATION\n---------------------')
    # Test case name
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))
    # Inputs available
    inputs = requests.get('{0}/inputs'.format(url)).json()
    print('Control Inputs:\t\t\t{0}'.format(inputs))
    # Measurements available
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

    for i in range(int(length / step)):
        y = requests.post('{0}/advance'.format(url), data=u).json()
        print(y['time'])
        if y == None:
            print('\n ERROR: Simulation failed')
            break

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
         'oveVFRSet4_activate': 0,
         'oveHeaOccSet_u': 273.15+21,
         'oveHeaOccSet_activate': 0,
         'oveHeaOccSet1_u': 273.15+21,
         'oveHeaOccSet1_activate': 0,
         'oveHeaOccSet2_u': 273.15+21,
         'oveHeaOccSet2_activate': 0,
         'oveHeaOccSet3_u': 273.15+21,
         'oveHeaOccSet3_activate': 0,
         'oveHeaOccSet4_u': 273.15+21,
         'oveHeaOccSet4_activate': 0,
         'oveHeaNonOccSet_u': 273.15+15.6,
         'oveHeaNonOccSet_activate': 0,
         'oveHeaNonOccSet1_u': 273.15+15.6,
         'oveHeaNonOccSet1_activate': 0,
         'oveHeaNonOccSet2_u': 273.15+15.6,
         'oveHeaNonOccSet2_activate': 0,
         'oveHeaNonOccSet3_u': 273.15+15.6,
         'oveHeaNonOccSet3_activate': 0,
         'oveHeaNonOccSet4_u': 273.15+15.6,
         'oveHeaNonOccSet4_activate': 0,
         'oveCooOccSet_u': 273.15+24,
         'oveCooOccSet_activate': 0,
         'oveCooOccSet1_u': 273.15+24,
         'oveCooOccSet1_activate': 0,
         'oveCooOccSet2_u': 273.15+24,
         'oveCooOccSet2_activate': 0,
         'oveCooOccSet3_u': 273.15+24,
         'oveCooOccSet3_activate': 0,
         'oveCooOccSet4_u': 273.15+24,
         'oveCooOccSet4_activate': 0,
         'oveCooNonOccSet_u': 273.15+26.7,
         'oveCooNonOccSet_activate': 0,
         'oveCooNonOccSet1_u': 273.15+26.7,
         'oveCooNonOccSet1_activate': 0,
         'oveCooNonOccSet2_u': 273.15+26.7,
         'oveCooNonOccSet2_activate': 0,
         'oveCooNonOccSet3_u': 273.15+26.7,
         'oveCooNonOccSet3_activate': 0,
         'oveCooNonOccSet4_u': 273.15+26.7,
         'oveCooNonOccSet4_activate': 0
         }

    return u


if __name__ == "__main__":
    res = run()
