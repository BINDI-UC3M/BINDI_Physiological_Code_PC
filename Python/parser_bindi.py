import os
import sys
import numpy as np
import re
from parser_functions import load_and_process

# Physiological data python parser - 23rd September 2024
#   Stores the signals in a txt called parser_output
#   Requires numpy and scipy (Currently tested for numpy 2.0.11)
#   To execute --> "python parser_bindi.py <function name - usually preprocess_folder> <folder with the data - data_raw> <True/Talse>"

def extract_number(string):
    match = re.search(r'\d+', string)
    return int(match.group()) if match else float('inf')

def preprocess_folder (filename, converted, previousdata):
    # previousdata = None
    # foldername = 'data_raw'
    # converted = True

    if os.path.exists(filename):
        #folder = os.path.dirname(__file__) + '/'+ foldername +'/'
        
        print(filename)
        signals = load_and_process(filename, converted)
        previousdata = signals

        with open('parser_output.txt', 'w+') as f:
            for items in signals:
                f.write('%s\n' %items)
        f.close()
        
        return signals
    else: 
        return ""    
    

def main ():
    args = sys.argv    
    globals()[args[1]](args[2],args[3],None)

if __name__ == '__main__':
    args = sys.argv    
    globals()[args[1]](args[2],args[3],None)