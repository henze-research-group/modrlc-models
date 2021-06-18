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
import json, collections
import time as _time
import os

def run(plot=False):
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
    # url = 'http://127.0.0.1:5000'
    
    url = 'http://0.0.0.0:5000'
    
    # Set simulation parameters
    length = 2 * 365 * 24 * 3600

    step = 7200

    simStartTime = 0
    warmupPeriod = 0
    
    heatingScenario1 = [36 * 24 * 3600, 42 * 24 * 3600] #Feb 5th to Feb 11th
    heatingScenario2 = [316 * 24 * 3600, 322 * 24 * 3600] #Nov 12th to Nov 18th
    coolingScenario1 = [127 * 24 * 3600, 133 * 24 * 3600] #May 7th to May 13th
    coolingScenario2 = [204 * 24 * 3600 , 210 * 24 * 3600] #Jul 23rd to Jul 29th
    heaCheck1 = True
    heaCheck2 = True
    cooCheck1 = True
    cooCheck2 = True
    
    # GET TEST INFORMATION
    # --------------------

    print('\nTEST CASE INFORMATION\n---------------------')
    # Test case name
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))
    # Default simulation step
    step_def = requests.get('{0}/step'.format(url)).json()
    print('Default Simulation Step:\t{0}'.format(step_def))
    # --------------------

    # RUN TEST CASE
    # -------------
    # Reset test case

    print('Initializing the simulation.')
    res = requests.put('{0}/initialize'.format(url), data={'start_time': heatingScenario1[0], 'warmup_period': warmupPeriod})
    if res:
        print('Successfully initialized the simulation')
    # Set simulation step
    print('Setting simulation step to {0}.'.format(step))
    res = requests.put('{0}/step'.format(url), data={'step': step})
    
    print('\nRunning heating scenario 1...')
    # Initialize u
    u = initializeControls()
    print('\nRunning controller script...')
    # Simulation Loop

    print('\nSimulating heating period 1: February 5th to February 11th...')
    length = heatingScenario1[1] - heatingScenario1[0]
    for i in range(int(length / step)):
        y = requests.post('{0}/advance'.format(url), data=u).json()
        print('Current simulated time: %d of %d' % (y['time'], heatingScenario1[1]), end = '\r')    
        if y == None:
            print('\n ERROR: Simulation of heating period 1 failed')
            heaCheck1 = False
            break       
        
    if heaCheck1:
        print('\nCOMPLETED: Heating scenario 1')
        
    print('\nSimulating cooling period 1: May 7th to May 13th...')
    jump = coolingScenario1[0] - heatingScenario1[1]
    length = coolingScenario1[1] - coolingScenario1[0]
    res = requests.put('{0}/step'.format(url), data={'step': jump})
    y = requests.post('{0}/advance'.format(url), data=u).json()
    res = requests.put('{0}/step'.format(url), data={'step': step})
    
    for i in range(int(length / step)):
        y = requests.post('{0}/advance'.format(url), data=u).json()
        print('Current simulated time: %d of %d' % (y['time'], coolingScenario1[1]), end = '\r')        
        if y == None:
            print('\n ERROR: Simulation of cooling period 1 failed')
            cooCheck1 = False
            break       
        
    if cooCheck1:
        print('\nCOMPLETED: Cooling scenario 1')
        
        
    print('\nSimulating cooling period 2: July 23rd to July 29th...')
    jump = coolingScenario2[0] - coolingScenario1[1]
    length = coolingScenario2[1] - coolingScenario2[0]
    res = requests.put('{0}/step'.format(url), data={'step': jump})
    y = requests.post('{0}/advance'.format(url), data=u).json()
    res = requests.put('{0}/step'.format(url), data={'step': step})
    
    for i in range(int(length / step)):
        y = requests.post('{0}/advance'.format(url), data=u).json()
        print('Current simulated time: %d of %d' % (y['time'], coolingScenario2[1]), end = '\r')         
        if y == None:
            print('\n ERROR: Simulation of cooling period 2 failed')
            cooCheck1 = False
            break       
        
    if cooCheck1:
        print('\nCOMPLETED: Cooling scenario 2')
        
    print('\nSimulating heating period 2: November 12th to November 18th...')
    
    jump = heatingScenario2[0] - coolingScenario2[1]
    length = heatingScenario2[1] - heatingScenario2[0]
    res = requests.put('{0}/step'.format(url), data={'step': jump})
    y = requests.post('{0}/advance'.format(url), data=u).json()
    res = requests.put('{0}/step'.format(url), data={'step': step})
    
    for i in range(int(length / step)):
        y = requests.post('{0}/advance'.format(url), data=u).json()
        print('Current simulated time: %d of %d' % (y['time'], heatingScenario2[1]), end = '\r')         
        if y == None:
            print('\n ERROR: Simulation of heating period 2 failed')
            heaCheck2 = False
            break       
        
    if heaCheck2:
        print('\nCOMPLETED: Heating scenario 2')



    print('\nTesting complete.')
    
    

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
         'oveVFRSet_u': 0.35,
         'oveVFRSet_activate': 0,
         'oveVFRSet1_u': 0.35,
         'oveVFRSet1_activate': 0,
         'oveVFRSet2_u': 0.35,
         'oveVFRSet2_activate': 0,
         'oveVFRSet3_u': 0.35,
         'oveVFRSet3_activate': 0,
         'oveVFRSet4_u': 0.35,
         'oveVFRSet4_activate': 0,
         'oveHeaSet_u': 273.15+21,
         'oveHeaSet_activate': 0,
         'oveHeaSet1_u': 273.15+21,
         'oveHeaSet1_activate': 0,
         'oveHeaSet2_u': 273.15+21,
         'oveHeaSet2_activate': 0,
         'oveHeaSet3_u': 273.15+21,
         'oveHeaSet3_activate': 0,
         'oveHeaSet4_u': 273.15+21,
         'oveHeaSet4_activate': 0,
         'oveCooSet_u': 273.15+24,
         'oveCooSet_activate': 0,
         'oveCooSet1_u': 273.15+24,
         'oveCooSet1_activate': 0,
         'oveCooSet2_u': 273.15+24,
         'oveCooSet2_activate': 0,
         'oveCooSet3_u': 273.15+24,
         'oveCooSet3_activate': 0,
         'oveCooSet4_u': 273.15+24,
         'oveCooSet4_activate': 0
         }

    return u

if __name__ == "__main__":
    res = run()
