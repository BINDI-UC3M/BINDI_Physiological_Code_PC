import re
import numpy as np
from scipy.signal import convolve

# Constant values
# LoR Coefficients for filterbank recovery
COEFFICIENTS_LOR = np.array([0.48296, 0.8365, 0.22414, -0.12940])
# Filterbank levels
NUM_FB_LEVELS = 2
# Filter shift to avoid overflow
FILTER_SHIFT = 4

# Extract all the numbers from one code line
def parse_line(line):
    match = re.search(r'\[([0-9]+),', line)
    if match:
        return int(match.group(1))

# Extract the data between brackets - only the data and not the MAC identifier or timestamp
def extract_data_between_brackets(line):
    match = re.search(r'\[([^\]]+)\]', line)
    if match:
        data_str = match.group(1)
        return list(map(int, data_str.split(',')))

# Conversions to avoid problems with signed and unsigned integers values from the microcontroller
# and considering the data size (hr: 3 bytes, gsr/skt/acc: 2 bytes)
def convert_to_binary_and_decimal(values, num_bytes):
    decimal_values = []
    for i in range(0, len(values), num_bytes):
        inverted_bytes = [format(value, '08b')[::-1] for value in values[i:i + num_bytes]]
        binary_values = ''.join(inverted_bytes)
        decimal_values.append(int(binary_values[::-1], 2))
    return decimal_values

# Find the typology of squeeze compression applied to the data (each type = 2 bits):
#   Type 00 = unpredictable
#   Type 01 = preceding neighbor fitting
#   Type 10 = linear-curve fitting
#   Type 11 = quadratic-curve fitting
def process_SZtypes(comptype_values):
    result = []
    # To extract the information is necessary to cut each byte in four pieces
    for value in comptype_values:
        # Transform data to 8 bits
        binary_value = format(value, '08b')
        # Split each byte in four blocks of 2 bits and convert them into a decimal value
        for i in range(0, 8, 2):
            pair_of_2_bits = int(binary_value[i:i+2], 2)
            result.append(pair_of_2_bits)
    return result

def process_SZvalues(sz_types, unpredictable):

    signal_vec = unpredictable[0:3]
    unpredict_counter = 3

    # Añadir valores adicionales a hr_final según hr_comptype_values_dec
    for value in sz_types:
        if value == 0:
            signal_vec.append(unpredictable[unpredict_counter])  # Añadir el valor correspondiente cuando value es 0
            unpredict_counter += 1
        elif value == 1:
            signal_vec.append(signal_vec[-1])  # Add the value from the previous position when value is 1
        elif value == 2:
            x = signal_vec[-1]
            y = signal_vec[-2]
            new_element = (2 * x) - y
            signal_vec.append(new_element)
        elif value == 3:
            x = signal_vec[-1]
            y = signal_vec[-2]
            z = signal_vec[-3]
            new_element = (3 * x) - (3 * y) + z
            signal_vec.append(new_element) 
    
    return signal_vec


# Accelerometer values are saved as signed integers in the microcontroller before applying 
# compression, for that reason is indispensable to apply this conversion
def adjust_acc_values(acc_values):
    adjusted_values = []
    for value in acc_values:
        int16_value = np.int16(np.uint16(value).astype(np.int16))
        adjusted_values.append(int16_value)
    return adjusted_values

# Filterbank n-level recovery: upsampling introducing zeros values in between and 
# then apply convolution with filterbank recovery coefficients 
def upsampling_y_filtrado(datos, niveles,borderEffect):
    for _ in range(niveles):   
        # Upsampling by a factor of 2
        datos_upsampled = np.zeros(2 * len(datos))
        datos_upsampled[::2] = datos
        # convolution with filterbank recovery filter daubechies
        datos = convolve(datos_upsampled, COEFFICIENTS_LOR, mode='full')[:len(datos_upsampled)]
    return datos[borderEffect:]

# If the conversion is activated, we apply the conversion factor to each of the signals
# and after recovery the signal from the bankfilter is required to recover the original 
# range as to avoid overflow a shift is applied
def apply_conversion(data_final, factor):
    if type(data_final) == list:
        data_final = np.array(data_final)
    converted_list = data_final*factor
    return converted_list
# Frame control, data associated and data length expected, data size in terms of bytes
# and compression level applied (0: no compressed; 1: only bankfilter; 2: bankfilter and squeeze)
frame_control = {'8':{'hr':{'length': 25, 'datasize': 3, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1},
                      'accx':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'accy':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'accz':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'gsr':{'length': 1, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':0.0013},
                      'skt':{'length': 1, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':0.005}}, 
                 '9':{'hr':{'length': 25, 'datasize': 3, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1},
                      'accx':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'accy':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'accz':{'length': 25, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':1/4096},
                      'gsr':{'length': 2, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':0.0013},
                      'skt':{'length': 2, 'datasize': 2, 'compression_level':0, 'bordereffects':0, 'conversion_factor':0.005}}, 
                 '13':{'hr':{'length': 79, 'datasize': 3, 'compression_level':1, 'bordereffects':4, 'conversion_factor':1}}, 
                 '15':{'gsr':{'length': 18, 'datasize': 2, 'compression_level':1, 'bordereffects':3, 'conversion_factor':0.0013}, 
                       'skt':{'length': 18, 'datasize': 2, 'compression_level':1, 'bordereffects':3, 'conversion_factor':0.005}}, 
                 '37':{'accx':{'length': 29, 'datasize': 2, 'compression_level':1, 'bordereffects':4, 'conversion_factor': 1/4096}, 
                       'accy':{'length': 29, 'datasize': 2, 'compression_level':1, 'bordereffects':4, 'conversion_factor': 1/4096}, 
                       'accz':{'length': 29, 'datasize': 2, 'compression_level':1, 'bordereffects':4, 'conversion_factor': 1/4096}},
                 '38':{'hr':{'length': 79, 'sz_type': 19, 'datasize': 3, 'compression_level':2, 'bordereffects':4, 'conversion_factor':1}},
                 '39':{'gsr':{'length': 18, 'sz_type': 4, 'datasize': 2, 'compression_level':2, 'bordereffects':3, 'conversion_factor':0.0013}, 
                       'skt':{'length': 18, 'sz_type': 4, 'datasize': 2, 'compression_level':2, 'bordereffects':3, 'conversion_factor':0.005}}, 
                 '40':{'accx':{'length': 29, 'sz_type': 7, 'datasize': 2, 'compression_level':2, 'bordereffects':4, 'conversion_factor': 1/4096}, 
                       'accy':{'length': 29, 'sz_type': 7, 'datasize': 2, 'compression_level':2, 'bordereffects':4, 'conversion_factor': 1/4096}, 
                       'accz':{'length': 29, 'sz_type': 7, 'datasize': 2, 'compression_level':2, 'bordereffects':4, 'conversion_factor': 1/4096}},
                }

def process_data_vector(data_vector, out_data, conversion, counter = None):
    # Number of bytes before the signal data
    header_bytes = 2
    # Assigned signals from the incoming parameters
    hr_data, gsr_data, skt_data, accx_data, accy_data, accz_data = out_data
    # Frame control data is sent in the 6 first bits of the package
    value = int((format(data_vector[0],'08b')[:6]),2)
    # print(value)
    # Types of frame control to parser
    fm_types = list(frame_control.keys())
    if str(value) in fm_types:
        # Depending on the header the specific information from the dictionary are selected
        dict_info = frame_control[str(value)]
        signals = list(dict_info.keys())

        # Initial reading index
        initial_read_index = header_bytes
        for signal_name in signals:
            # Variable names
            variable_name = signal_name + '_data'
            # counter_name = signal_name + '_counter'
            
            # Assign parameters
            data_length = dict_info[signal_name]['length']
            data_size = dict_info[signal_name]['datasize']
            factor = dict_info[signal_name]['conversion_factor']
            data_compresion_level = dict_info[signal_name]['compression_level']
            repeat_bordereffect = dict_info[signal_name]['bordereffects']
            data_bordereffect = repeat_bordereffect * 2 * NUM_FB_LEVELS

            # Data recovery according to compression level
            if (data_compresion_level == 0):
                # Select the part of the vector where the signal data
                signal_line = data_vector[initial_read_index:(initial_read_index + (data_length*data_size))]
                signal_vector = convert_to_binary_and_decimal(signal_line, data_size)
                if(signal_name in ['accx','accy','accz']):
                    signal_vector = adjust_acc_values(signal_vector)
                # Once the data is read, the initial_read_index is reassigned
                initial_read_index = initial_read_index + (data_length*data_size)
            elif (data_compresion_level == 1):
                # Select the part of the vector where the signal data
                signal_line = data_vector[initial_read_index:(initial_read_index + (data_length*data_size))]
                signal_vector = convert_to_binary_and_decimal(signal_line, data_size)
                # acc signal is saved and compressed in the microcontroller as signed, so for the recovery
                # an adjustment is required
                if(signal_name in ['accx','accy','accz']):
                    signal_vector = adjust_acc_values(signal_vector)
                # Filterbank recovery
                signal_vector = upsampling_y_filtrado(signal_vector, NUM_FB_LEVELS,data_bordereffect)
                signal_vector = apply_conversion(signal_vector, FILTER_SHIFT)
                # Once the data is read, the initial_read_index is reassigned
                initial_read_index = initial_read_index + (data_length*data_size)
            elif(data_compresion_level == 2):
                sz_type = dict_info[signal_name]['sz_type']
                # In the squeeze compression 
                comp_sz_types = data_vector[initial_read_index:(initial_read_index + sz_type)]
                initial_read_index = initial_read_index + sz_type
                sz_types = process_SZtypes(comp_sz_types)
                # In some cases not all the bits of the data type are complete, for that reason depending on the 
                # total number of samples expected we compute the number of types required:
                # **Important the 3 three first values are always unpredictable and their types are not included
                number_of_types_expected = (data_length-3)
                # Number of unpredicted values (always at least the three initial values are unpredictable)
                unpred_samples = sz_types[:number_of_types_expected].count(0) + 3 
                unpredict_values = data_vector[initial_read_index:(initial_read_index + (unpred_samples*data_size))]
                initial_read_index = initial_read_index + (unpred_samples*data_size)
                unpredict_values = convert_to_binary_and_decimal(unpredict_values, data_size)
                # Based on the types of squeeze compression and the unpredictable samples, we recover the 
                # signal one-level compressed 
                signal_vector = process_SZvalues(sz_types[:number_of_types_expected], unpredict_values)
                # acc signal is saved and compressed in the microcontroller as signed, so for the recovery
                # an adjustment is required
                if(signal_name in ['accx','accy','accz']):
                    signal_vector = adjust_acc_values(signal_vector)
                # Filterbank recovery
                signal_vector = upsampling_y_filtrado(signal_vector, NUM_FB_LEVELS, data_bordereffect)
                signal_vector = apply_conversion(signal_vector, FILTER_SHIFT)

            if conversion:
                signal_vector = apply_conversion(signal_vector, factor)

            eval(variable_name + '.extend(signal_vector.tolist())')


    out_data = [hr_data, gsr_data, skt_data, accx_data, accy_data, accz_data]
    
    return out_data


def load_and_process(filename, conversion, previous=None):
    if previous == None:
        hr_out, gsr_out, skt_out, accx_out, accy_out, accz_out = [], [], [], [], [], []
    else:
        hr_out, gsr_out, skt_out, accx_out, accy_out, accz_out = previous
    
    out_signals = [hr_out, gsr_out, skt_out, accx_out, accy_out, accz_out]

    with open(filename, 'r') as file:
        for line in file:
            line_vector = extract_data_between_brackets(line)
            if line_vector:
                out_signals = process_data_vector(line_vector, out_signals, conversion)

    return out_signals

