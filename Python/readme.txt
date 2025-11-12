** Python Code for Feature Extraction ** 
This code represents the initial translation to Python for the parser and feature extraction. 
It can be used for signals from EH and Bindi, and contains the scripts for both types of parsers. 
Additionally, one of the models is also included for inference.

- To execute the code locally just press run and debug, it will ask you to select the folder you want to process
- Some parameters are currently fixed but can be passed through arguments:
    - sys.argv[1] = data_type (Bindi or EH)
    - sys.argv[2] = overlap_csv (% of overlap for the featuremap to call the model)

- Libraries: this code has been developed using Python 3.12, for the model the tensorflow version must be 2.19 or lower
    If the PC used has no GPU pyopencl and some others may cause some trouble but can be solved by changing environment variables or downloading a cpu-only version