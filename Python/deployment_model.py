import sys
import os #some variables to make execution less noisy
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
os.environ["TF_ENABLE_ONEDNN_OPTS"] = "0"
from pathlib import Path
import pandas as pd
import numpy as np
np.random.seed(0)
import torch
torch.manual_seed(0)
import tensorflow as tf
tf.random.set_seed(0)
import keras
keras.utils.set_random_seed(0)


"""
The installation of this code within the server requires specific library versions
python 3.12.7, tensorflow 2.19.0 (version máxima antes de que el interpreter este deprecado)

Notas: Comprobar con extraccion las versiones
Warning: tf.lite.Interpreter is deprecated and is scheduled for deletion in
    TF 2.20. Please use the LiteRT interpreter from the ai_edge_litert package.

"""
def tflite_inference(interpreter, x_tensor):
    """
    Inference computation using the interpreter of a TensorflowLite model.
    Args:
        interpreter (tf.lite.Interpreter): Tensorflow Lite interpreter of the model
        x_tensor (tf.tensor): Tensor with the input data of the model
    Returns:
        BasicLoader: loader with the dataset
    """
    input_details  = interpreter.get_input_details()[0]
    input_scale, input_zero_point = input_details["quantization"]
    output_details = interpreter.get_output_details()[0]
    
    # Compute how many inferences are required 
    # *IMPORTANT: Only one inference per round
    test_indices = range(x_tensor.shape[0])
    # Based on the number of predictions a vector of that size is initialized
    preds = np.zeros((len(test_indices),), dtype=float)
    out_act = np.zeros((len(test_indices),2), dtype=float)

    for t_indx in test_indices:
        x2infe = x_tensor[t_indx] # type: ignore      
    
        if input_details['dtype'] == np.int8 and x2infe.dtype != tf.int8:
            x2infe = x2infe / input_scale + input_zero_point     
    
        x2infe =  tf.cast(np.expand_dims(x2infe, axis=0),input_details["dtype"])
        interpreter.set_tensor(input_details["index"], x2infe)
        interpreter.invoke()
        prediction = interpreter.get_tensor(output_details["index"])[0]
        preds[t_indx] = prediction.argmax() 
        out_act[t_indx] = prediction

    return [preds, out_act]

def tfmicro_preds(filename, interpreter, params):
    [features,featmap_size] = params
    input_details  = interpreter.get_input_details()[0]

    x_data = pd.read_csv(filename, header = None)
    # x_data = np.array(x_data, dtype = input_details['dtype'])
    x_data = np.reshape(x_data, (-1,features,featmap_size,1))
    
    x_tensor = tf.convert_to_tensor(x_data) # type: ignore
    preds, softmax_out = tflite_inference(interpreter, x_tensor)

    return [preds, softmax_out]

def load_tfmicro_interpreter(tflite_model_path: Path):
    interpreter = tf.lite.Interpreter(model_path=str(tflite_model_path))
    return interpreter

def model_deployment(data_path:Path, 
                     model_path:Path,
                     params:tuple = (57,10)):
    
    interpreter = load_tfmicro_interpreter(model_path)
    interpreter.allocate_tensors()
    pred, _ = tfmicro_preds(filename=data_path, 
                         interpreter = interpreter, 
                         params = params)
    
    # guardar
    print("Tenemos la prediccion")
    print(pred)
    return pred
	
	
def main(feature_map):	    
    #args = sys.argv
    if (os.path.exists("./model/model_quant.tflite")):
        #args = ["", "./model/test_data.txt", "./model/model_quant.tflite"]
        try:
            path_file = feature_map #Path(args[1])
            path_model = "./model/model_quant.tflite" # Path(args[2]) So far model will always be in the same place
            print(f'El archivo de entrada esta en: {str(path_file)}') #AQUÍ NO ESTAMOS PASANDO UN CAMINO SINO UNA VARIABLE DIRECTAMENTE
            print(f'El modelo de entrada esta en: {str(path_model)}')
            pred = model_deployment(data_path=path_file, model_path=path_model)
            return pred
        except:
            print("Problemas en los parametros de entrada")

        #globals()["model_deployment"](data_path= path_file, model_path= path_model)

    else: 
        print("Model not found")
        exit() 