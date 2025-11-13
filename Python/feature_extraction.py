#IMPORTANDO LIBRERIAS
import sys
import logging
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

import scipy
from scipy import signal
from scipy.signal import decimate
from scipy.stats import kurtosis
from scipy.stats import skew
from scipy.signal import welch
from scipy.signal import filtfilt, firwin
from scipy.ndimage import median_filter
#from scipy.integrate import simps
from skdim.id import CorrInt

import csv
import os
#import heartpy as hp
import math
import matplotlib.pyplot as plt
#import neurokit2 as nk
import numpy as np
from scipy.signal import medfilt
#LIBRERIAS NECESARIAS
import os
import re
import pandas as pd
import numpy as np
import tkinter as tk
from tkinter import filedialog
from collections import Counter
import statistics
from datetime import datetime
import matplotlib.pyplot as plt


import nolds

import pyrqa
from pyrqa.time_series import TimeSeries
from pyrqa.settings import Settings
from pyrqa.analysis_type import Classic
from pyrqa.neighbourhood import FixedRadius
from pyrqa.metric import EuclideanMetric
from pyrqa.computation import RQAComputation
from scipy import interpolate
from scipy.interpolate import interp1d
from scipy.signal import periodogram
import numpy as np
from scipy.stats import skew, kurtosis
from numpy.polynomial.polynomial import Polynomial
import numpy as np
import neurokit2 as nk
import matplotlib.pyplot as plt
import scipy.integrate as spi
import nolds

from scipy.signal import find_peaks
from scipy.signal import butter, filtfilt
from scipy.spatial.distance import pdist, squareform
from scipy.signal import find_peaks
from scipy.stats import entropy
from scipy.signal import decimate
from scipy.ndimage import label, generate_binary_structure
from scipy import stats, optimize
from scipy.signal import stft
#from scipy.integrate import simps
import os
#import pyopencl as cl
from scipy.io import loadmat

#OTROS SCRIPTS QUE SE EJECUTAN
import autoParser_v2 #REVISAR COMO LLAMAR A ESTO
import parser_bindi
import deployment_model


os.environ['PYOPENCL_COMPILER_OUTPUT'] = '1'


#PARA LOS MENSAJES DE DEBUG E INFORMACIÓN
import colorlog

# Create a colored formatter
formatter = colorlog.ColoredFormatter(
    '%(log_color)s%(levelname)s:%(reset)s %(message)s',
    log_colors={
        'DEBUG': 'cyan',
        'INFO': 'green',
        'WARNING': 'yellow',
        'ERROR': 'red',
        'CRITICAL': 'red,bg_white',
    }
)

# Setup handler
handler = logging.StreamHandler()
handler.setFormatter(formatter)

# Setup logger
logger = logging.getLogger()
logger.addHandler(handler)
logger.setLevel(logging.DEBUG) #CHANGE TO INFO OR WARNING TO REMOVE MESSAGES
#logging.basicConfig(level=logging.DEBUG)

def read_vector_from_txt(filename):
    vector = []
    with open(filename, 'r') as file:
        for line in file:
            #value = float(line.strip())
            value = np.float64(line.strip())
            vector.append(value)
    return vector

# --- Normalize to range 1–1024 ---
def mapfun(x, in_min, in_max, out_min, out_max):
    """Map values linearly from one range to another."""
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

def BVP_filter(bvp_raw, samprate_bvp):
    # Function to filter the HR signal
    # para obtener las señales como en el matlab tiene dos filtros
    FIRs = loadmat('FIRs.mat')
    # Filter the GSR signal
    coeffs_skt = FIRs['Coeffs_BVP'].flatten() #EN EL MATLAB ESTÁN PUESTOS LOS MISMOS COEFICIENTES
    padlen = min(len(bvp_raw) // 2, 3 * (len(coeffs_skt) - 1))

    bvp_filtered = filtfilt(coeffs_skt, 1,bvp_raw, padlen = padlen)

    #Remove baseline wonder
    #butterworth y luego filtfilt
    Wc = (2 * 0.5) / samprate_bvp  # normalized cutoff (same as MATLAB)
    b, a = butter(3, Wc)  # 3rd-order lowpass Butterworth
    # Apply zero-phase filtering
    bvp_filtered_1 = filtfilt(b, a, bvp_filtered)
    # Add DC offset by max(abs(raw))
    bvp_filtered_2 = np.max(np.abs(bvp_filtered_1)) + bvp_filtered_1 #REVISAR
    # Output signal
    bvp_filt_baseline = bvp_filtered_2

    #Enhace peaks
    hmean = np.mean(bvp_filt_baseline)
    minim = hmean
    maxim = hmean

    # --- Cubing/squaring process ---
    # Square each element
    bvp_filt_baseline_1 = bvp_filt_baseline ** 2

    # Update min and max from the squared values
    minim = np.min(bvp_filt_baseline_1)
    maxim = np.max(bvp_filt_baseline_1)

    raw = mapfun(bvp_filt_baseline_1, minim, maxim, 1, 1024)

    bvp_filt_baseline_enhanced = raw

    # Automatic gain control
    #agc_ecg = filtered_ecg / np.max(np.abs(filtered_ecg))  # Normalize the signal
    #hr_windows[i] = agc_ecg  # Update the original element in the list
    return bvp_filt_baseline_enhanced

def GSR_filter(gsr_raw, samprate_gsr, data_type):
    # Function to filter the GSR signal
    # perform filt-filt + downsample + media móvil
    FIRs = loadmat('FIRs.mat')
    downsample_gsr = samprate_gsr/10 #Para cambiar de 200Hz a 10 
    # Filter the GSR signal
    coeffs_gsr = FIRs['Coeffs_GSR'].flatten()
    padlen = min(len(gsr_raw) // 2, 3 * (len(coeffs_gsr) - 1))

    gsr_filtered = filtfilt(coeffs_gsr, 1,gsr_raw, padlen = padlen)

    # Convert to microsiemens
    gsr_uS_filtered = -(1000000.0 * gsr_filtered) / (gsr_filtered - 16383)

    # Downsample the signal
    #gsr_uS_filtered_dn = gsr_uS_filtered[::downsample_gsr]
    if data_type == 'EH': 
        gsr_uS_filtered_dn = signal.decimate(gsr_uS_filtered, int(downsample_gsr))

        # Apply moving mean followed by moving median
        window_size_mean = int(samprate_gsr / downsample_gsr)
        window_size_median = int((samprate_gsr / downsample_gsr) / 2)

        # Moving mean
        temp = np.convolve(gsr_uS_filtered_dn,np.ones(window_size_mean) / window_size_mean, mode='same')

        # Moving median
        gsr_uS_filtered_dn_sm =  median_filter(temp, size=window_size_median)
    
    else:
        gsr_uS_filtered_dn_sm = gsr_uS_filtered

    return gsr_uS_filtered_dn_sm #REVISAR SI ESTO ES LO QUE QUIERO DEVOLVER

def SKT_filter(skt_raw, samprate_skt, data_type):
    # Function to filter the SKt signal
    # perform filt-filt + downsamples + media móvil
    FIRs = loadmat('FIRs.mat')
    samprate_skt = 200
    downsample_skt = samprate_skt/10 #Para cambiar de 200Hz a 10 
    # Filter the GSR signal
    coeffs_skt = FIRs['Coeffs_GSR'].flatten() #EN EL MATLAB ESTÁN PUESTOS LOS MISMOS COEFICIENTES
    padlen = min(len(skt_raw) // 2, 3 * (len(coeffs_skt) - 1))

    skt_filtered = filtfilt(coeffs_skt, 1,skt_raw, padlen = padlen)

    if data_type == 'EH':
        # Downsample the signal
        skt_filtered_dn = signal.decimate(skt_filtered, int(downsample_skt))

        # Apply moving mean followed by moving median
        window_size_mean = int(samprate_skt / downsample_skt)
        window_size_median = int((samprate_skt / downsample_skt) / 2)

        # Moving mean
        temp = np.convolve(skt_filtered_dn,np.ones(window_size_mean) / window_size_mean, mode='same')

        # Moving median
        skt_filtered_dn_sm =  median_filter(temp, size=window_size_median)
    else:
        skt_filtered_dn_sm = skt_filtered
    return skt_filtered_dn_sm #REVISAR SI ESTO ES LO QUE QUIERO DEVOLVER

def bandpass_filter(signal, fs, lowcut, highcut, order=4):
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(order, [low, high], btype='band')
    return filtfilt(b, a, signal)

def compute_band_energy(signal):
    return np.sum(signal ** 2)

def compute_energy_bands(hr_signal, fs):
    # Filtered bands
    lf = bandpass_filter(hr_signal, fs, 0.0001, 0.1)
    hf = bandpass_filter(hr_signal, fs, 0.1, 0.2)
    #uhf = bandpass_filter(hr_signal, fs, 0.4, 1.0)  # adjust upper bound if needed

    # Compute energy
    energy_lf = compute_band_energy(lf)
    energy_hf = compute_band_energy(hf)
    #energy_uhf = compute_band_energy(uhf)

    return energy_lf, energy_hf #, energy_uhf

def band_energy_welch(signal, fs, band, nperseg=200):
    freqs, psd = welch(signal, fs=fs, nperseg=nperseg)
    idx_band = np.logical_and(freqs >= band[0], freqs <= band[1])
    band_power = np.trapz(psd[idx_band], freqs[idx_band])  # Integrate PSD over band
    return band_power

def compute_hrv_bands(signal, fs):
    lf_band = (0.0000001, 0.1)
    hf_band = (0.1, 0.2)
    #uhf_band = (0.4, 1.0)

    lf_energy = band_energy_welch(signal, fs, lf_band)
    hf_energy = band_energy_welch(signal, fs, hf_band)
    #uhf_energy = band_energy_welch(signal, fs, uhf_band)

    return lf_energy, hf_energy #, uhf_energy

def bandas_frec(fft_HRV, vector_frecuencia):
    """
    Classify frequency components into LF, HF, and UHF bands.
    
    Args:
        fft_HRV: Array of FFT coefficients
        vector_frecuencia: Array of corresponding frequencies
        
    Returns:
        Tuple of (LF_signal, HF_signal, UHF_signal) as numpy arrays
    """
    # Convert inputs to numpy arrays if they aren't already
    fft_HRV = np.asarray(fft_HRV)
    vector_frecuencia = np.asarray(vector_frecuencia)
    
    # Create masks for each frequency band
    lf_mask = (vector_frecuencia >= 0.04) & (vector_frecuencia <= 0.15)
    hf_mask = (vector_frecuencia > 0.15) & (vector_frecuencia <= 0.4)
    uhf_mask = (vector_frecuencia > 0.4) & (vector_frecuencia <= 1)
    
    # Apply masks to get signals for each band
    LF_signal = fft_HRV[lf_mask]
    HF_signal = fft_HRV[hf_mask]
    UHF_signal = fft_HRV[uhf_mask]
    
    # Ensure non-empty arrays
    LF_signal = LF_signal if LF_signal.size > 0 else np.array([0.0])
    HF_signal = HF_signal if HF_signal.size > 0 else np.array([0.0])
    UHF_signal = UHF_signal if UHF_signal.size > 0 else np.array([0.0])
    
    return LF_signal, HF_signal, UHF_signal

def relative_power(target_energy, reference_energy1, reference_energy2):
    """
    Calculate relative power of a frequency band.
    
    Args:
        target_energy: Energy of the target band
        reference_energy1: Energy of first reference band
        reference_energy2: Energy of second reference band
        
    Returns:
        Relative power as float
    """
    total = target_energy + reference_energy1 + reference_energy2
    return np.abs(target_energy / total) if total != 0 else 0.0

def calculate_ratios_and_energies(LF_energia, HF_energia, UHF_energia):
    """
    Calculate various ratios and normalized energies from frequency band energies.
    
    Args:
        LF_energia: Low frequency band energy
        HF_energia: High frequency band energy
        UHF_energia: Ultra high frequency band energy
        
    Returns:
        Tuple of (Ratio_LFHF, LFnorm, HFnorm, Rel_power_LF, Rel_power_HF, Rel_power_UHF)
    """
    # Convert inputs to floats to avoid integer division
    LF_energia = float(LF_energia)
    HF_energia = float(HF_energia)
    UHF_energia = float(UHF_energia)
    
    # Ratios between bands LF and HF
    Ratio_LFHF = np.abs(LF_energia / HF_energia) if HF_energia != 0 else np.inf
    
    # Normalized energies
    total_energy = LF_energia + HF_energia
    if total_energy != 0:
        LFnorm = np.abs(LF_energia / total_energy)
        HFnorm = np.abs(HF_energia / total_energy)
    else:
        LFnorm = HFnorm = 0.0
    
    # Relative powers
    Rel_power_LF = relative_power(LF_energia, HF_energia, UHF_energia)
    Rel_power_HF = relative_power(HF_energia, LF_energia, UHF_energia)
    Rel_power_UHF = relative_power(UHF_energia, HF_energia, LF_energia)
    
    return Ratio_LFHF, LFnorm, HFnorm, Rel_power_LF, Rel_power_HF, Rel_power_UHF

# Calculate log energies with numerical stability
def safe_log(x):
    return np.log(x) if x > 0 else 0.0


def phase_space_reconstruction(signal, max_lag=1, max_dim=3):
    signal = np.asarray(signal)
    N = len(signal)
    if max_lag < 1 or max_dim < 1:
        raise ValueError("MaxLag and MaxDim must be greater than or equal to 1")

    # Crear la matriz para la reconstrucción del espacio de fases
    phase_space = np.zeros((N - (max_dim - 1) * max_lag, max_dim))

    # Rellenar la matriz con los valores correspondientes
    for i in range(max_dim):
        phase_space[:, i] = signal[i * max_lag:N - (max_dim - 1 - i) * max_lag]
    
    return phase_space

def cerecurr_y(signal):
    len_signal = len(signal)
    N = len_signal
    Y = signal
    buffer = np.zeros((N, N))

    for i in range(N):
        x0 = i
        for j in range(i, N):
            y0 = j
            # Calculate the Euclidean distance
            distance = np.linalg.norm(Y[i] - Y[j])
            # Store the distance symmetrically in the buffer
            buffer[x0, y0] = distance
            buffer[y0, x0] = distance
    
    return buffer

def compute_rqa(signal, dim=3, tau=1, threshold=0.1, l_min=2, v_min=2):
    """
    Perform Recurrence Quantification Analysis with extended metrics.
    
    Parameters:
        signal (array): Input signal
        dim (int): Embedding dimension
        tau (int): Time delay
        threshold (float): Recurrence threshold
        l_min (int): Minimum diagonal line length
        v_min (int): Minimum vertical line length
        
    Returns:
        dict: RQA metrics including:
            RR: Recurrence rate
            DET: Determinism
            L_max: Longest diagonal line
            ENTR: Entropy of diagonal lines
            LAM: Laminarity
            TT: Trapping time
        array: Recurrence matrix
    """
    # Phase space reconstruction
    trajectory = phase_space_reconstruction(signal, dim, tau)
    
    # Compute distance matrix and recurrence matrix
    dist_matrix = squareform(pdist(trajectory, 'euclidean'))
    recurrence_matrix = (dist_matrix <= threshold).astype(int)
    np.fill_diagonal(recurrence_matrix, 0)  # Remove identity line
    
    n = len(recurrence_matrix)
    N = n**2 - n  # Total possible recurrences excluding main diagonal
    
    # Calculate basic metrics
    RR = np.sum(recurrence_matrix) / N  # Recurrence rate
    
    # Initialize metric variables
    diagonal_lines = []
    vertical_lines = []
    L_max = 0
    ENTR = 0
    LAM = 0
    TT = 0
    
    # Analyze diagonal and vertical lines
    for i in range(-n+1, n):
        # Diagonal lines (for DET, L_max, ENTR)
        diag = np.diagonal(recurrence_matrix, i)
        if len(diag) > 1:
            # Find sequences of 1s (recurrences)
            diff = np.diff(np.concatenate([[0], diag, [0]]))
            starts = np.where(diff == 1)[0]
            ends = np.where(diff == -1)[0]
            lengths = ends - starts
            diagonal_lines.extend(lengths[lengths >= l_min])
            if len(lengths) > 0:
                L_max = max(L_max, np.max(lengths))
        
        # Vertical lines (for LAM, TT)
        if i >= 0:  # Only need to check one triangle
            col = recurrence_matrix[:, i]
            if len(col) > 1:
                diff = np.diff(np.concatenate([[0], col, [0]]))
                starts = np.where(diff == 1)[0]
                ends = np.where(diff == -1)[0]
                lengths = ends - starts
                vertical_lines.extend(lengths[lengths >= v_min])
    
    # Calculate diagonal-based metrics
    diagonal_lines = np.array(diagonal_lines)
    if len(diagonal_lines) > 0:
        DET = np.sum(diagonal_lines) / np.sum(recurrence_matrix)
        L_max = np.max(diagonal_lines)
        
        # Calculate entropy (using histogram with bins up to max length)
        hist, _ = np.histogram(diagonal_lines, bins=np.arange(0.5, L_max+1.5))
        prob = hist / np.sum(hist)
        prob = prob[prob > 0]  # Remove zero probabilities
        ENTR = -np.sum(prob * np.log(prob))
    else:
        DET = 0
        L_max = 0
        ENTR = 0
    
    # Calculate vertical-based metrics (LAM and TT)
    vertical_lines = np.array(vertical_lines)
    if len(vertical_lines) > 0:
        LAM = np.sum(vertical_lines) / np.sum(recurrence_matrix)
        TT = np.mean(vertical_lines) if len(vertical_lines) > 0 else 0
    else:
        LAM = 0
        TT = 0
    
    metrics = {
        'RR': RR,          # Recurrence rate
        'DET': DET,        # Determinism
        'L_max': L_max,     # Longest diagonal line
        'ENTR': ENTR,       # Entropy of diagonal lines
        'LAM': LAM,         # Laminarity
        'TT': TT           # Trapping time
    }
    
    return metrics, recurrence_matrix

from scipy.stats import linregress

def DFA_fun(data, pts=None, order=1):
    """
    Python implementation of DFA (Detrended Fluctuation Analysis)
    
    Parameters:
    -----------
    data : array-like
        A one-dimensional data vector
    pts : array-like, optional
        Sizes of the windows/bins at which to evaluate the fluctuation
        If not specified, defaults to (floor((len(data)/500)):10:floor((len(data)/10)))
    order : int, optional
        Order of the polynomial for the local trend correction (default=1)
    
    Returns:
    --------
    A : numpy.ndarray
        A 2x1 array where A[0] is the scaling coefficient "alpha",
        and A[1] is the intercept of the log-log regression
    F : numpy.ndarray
        A vector containing the fluctuations corresponding to the window sizes in pts
    """
    
    # Check inputs and set defaults
    if pts is None:
        pts = np.arange(np.floor(len(data)/500), np.floor(len(data)/10), 10, dtype=int)
    
    # Ensure data is a column vector
    data = np.array(data)
    if data.ndim == 1:
        data = data.reshape(-1, 1)
    elif data.shape[0] < data.shape[1]:
        data = data.T
    
    # Check window sizes
    if np.min(pts) == order + 1:
        print(f'WARNING: The smallest window size is {np.min(pts)}. DFA order is {order}.')
        print('This severely affects the estimate of the scaling coefficient')
        print('(If order == 1, the corresponding fluctuation is zero.)')
    elif np.min(pts) < (order + 1):
        print(f'ERROR: The smallest window size is {np.min(pts)}. DFA order is {order}:')
        print(f'Aborting. The smallest window size should be of {order+1} points at least.')
        return None, None
    
    npts = len(pts)
    F = np.zeros(npts)
    N = len(data)
    Nfloor = np.zeros(npts, dtype=int)
    
    for h in range(npts):
        w = pts[h]
        n = int(np.floor(N / w))
        Nfloor[h] = n * w
        D = data[:Nfloor[h]]
        
        y = np.cumsum(D - np.mean(D))
        
        bin_edges = np.arange(0, Nfloor[h], w, dtype=int)
        vec = np.arange(1, w+1)
        
        # Polynomial fitting and evaluation for each bin
        y_hat = np.zeros_like(y)
        for j in range(n):
            start = bin_edges[j]
            end = start + w
            if end > len(y):
                break
            coeff = np.polyfit(vec, y[start:end].flatten(), order)
            y_hat[start:end] = np.polyval(coeff, vec)
        
        F[h] = np.sqrt(np.mean((y.flatten() - y_hat.flatten())**2))
    
    # Linear regression in log-log space
    log_pts = np.log(pts)
    log_F = np.log(F)
    slope, intercept, _, _, _ = linregress(log_pts, log_F)
    A = np.array([slope, intercept])
    
    return A, F


def tdrecurr_y(recurdata, threshold):
    """
    Generates a thresholded (black-white) recurrence plot.
    
    Args:
        recurdata: 2D array (distance matrix or similarity matrix).
        threshold: Scalar threshold value for binarization.
    
    Returns:
        Binary recurrence plot (1 = recurrence, 0 = no recurrence).
    """
    return (recurdata <= threshold).astype(int)


def recurrqa_y(recurr_plot):
  
    N = recurr_plot.shape[0]
    total_points = N * N
    
    # --- Recurrence Rate (REC) ---
    REC = np.sum(recurr_plot) / total_points

    # --- Diagonal line analysis ---
    def extract_diagonal_lengths(matrix):
        lengths = []
        for offset in range(-N + 1, N):
            diag = np.diagonal(matrix, offset=offset)
            count = 0
            for val in diag:
                if val:
                    count += 1
                else:
                    if count >= 2:
                        lengths.append(count)
                    count = 0
            if count >= 2:
                lengths.append(count)
        return lengths

    diag_lengths = extract_diagonal_lengths(recurr_plot)
    
    if diag_lengths:
        DET = np.sum(diag_lengths) / np.sum(recurr_plot)
        LMAX = np.max(diag_lengths)
        unique_lengths, counts = np.unique(diag_lengths, return_counts=True)
        prob = counts / np.sum(counts)
        ENTR = -np.sum(prob * np.log2(prob))
    else:
        DET = LMAX = ENTR = 0.0

    # --- Vertical line analysis ---
    def extract_vertical_lengths(matrix):
        lengths = []
        for col in range(matrix.shape[1]):
            count = 0
            for row in range(matrix.shape[0]):
                if matrix[row, col]:
                    count += 1
                else:
                    if count >= 2:
                        lengths.append(count)
                    count = 0
            if count >= 2:
                lengths.append(count)
        return lengths

    vert_lengths = extract_vertical_lengths(recurr_plot)
    
    if vert_lengths:
        LAM = np.sum(vert_lengths) / np.sum(recurr_plot)
        TT = np.mean(vert_lengths)
    else:
        LAM = TT = 0.0

    return {
        "REC": REC, "DET": DET, "LMAX": LMAX,
        "ENTR": ENTR, "LAM": LAM, "TT": TT
    }

def recurrqa_y_2(recurr_plot):
    """
    Computes RQA statistics without `skimage`.
    """
    N = recurr_plot.shape[0]
    total_points = N * N
    
    # --- Recurrence Rate (REC) ---
    REC = np.sum(recurr_plot) / total_points
    
    # --- Diagonal line analysis (DET, LMAX, ENTR) ---
    structure = generate_binary_structure(2, 2)
    labeled_diag, num_features = label(recurr_plot, structure=structure)
    
    # Get diagonal line lengths manually (without skimage)
    diag_lengths = []
    for i in range(1, num_features + 1):
        diag_lengths.append(np.sum(labeled_diag == i))
    diag_lengths = [l for l in diag_lengths if l >= 2]  # Filter single points
    
    if diag_lengths:
        DET = np.sum(diag_lengths) / np.sum(recurr_plot)
        LMAX = np.max(diag_lengths)
        # Entropy calculation
        unique_lengths, counts = np.unique(diag_lengths, return_counts=True)
        prob = counts / np.sum(counts)
        ENTR = -np.sum(prob * np.log2(prob))
    else:
        DET = LMAX = ENTR = 0.0
    
    # --- Vertical line analysis (LAM, TT) ---
    labeled_vert, num_vert = label(recurr_plot.T, structure=structure)
    vert_lengths = []
    for i in range(1, num_vert + 1):
        vert_lengths.append(np.sum(labeled_vert == i))
    vert_lengths = [l for l in vert_lengths if l >= 2]
    
    if vert_lengths:
        LAM = np.sum(vert_lengths) / np.sum(recurr_plot)
        TT = np.mean(vert_lengths)
    else:
        LAM = TT = 0.0
    
    return {
        "REC": REC, "DET": DET, "LMAX": LMAX, 
        "ENTR": ENTR, "LAM": LAM, "TT": TT
    }

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks, periodogram
from sklearn.preprocessing import minmax_scale

def debug_BVP_features(bvp_raw, bvp_samprate, bvp_features):
    """
    Visualizes the BVP signal and its extracted features for debugging and validation.

    Parameters
    ----------
    bvp_raw : np.ndarray
        Raw BVP signal.
    bvp_samprate : float
        Sampling frequency (Hz).
    bvp_features : dict or tuple
        Output from BVP_features_extr(), ideally a dict mapping feature names to values.
    """

    #time = np.arange(len(bvp_raw)) / bvp_samprate
    time = np.arange(len(bvp_raw)) / float(bvp_samprate)
    bvp_raw = np.asarray(bvp_raw, dtype=float)


    # === 1. Raw BVP Signal with Detected Peaks ===
    peaks, _ = find_peaks(bvp_raw, distance=0.4 * bvp_samprate)
    peaks = np.asarray(peaks, dtype=int) 
    plt.figure(figsize=(14, 4))
    plt.plot(time, bvp_raw, label='BVP Signal')
    plt.plot(time[peaks], bvp_raw[peaks], 'rx', label='Detected Peaks')
    plt.title("BVP Signal & Detected Peaks")
    plt.xlabel("Time (s)")
    plt.ylabel("Amplitude")
    plt.legend()
    plt.grid(True)
    plt.show()

    # === 2. Inter-Beat Intervals (IBI) ===
    ibi_ms = np.diff(peaks / bvp_samprate)
    plt.figure(figsize=(10, 3))
    plt.plot(ibi_ms * 1000, marker='o')
    plt.title("Inter-Beat Intervals (IBI)")
    plt.xlabel("Beat index")
    plt.ylabel("IBI (ms)")
    plt.grid(True)
    plt.show()

    # === 3. Frequency Domain Analysis ===
    time_diff = np.diff(peaks / bvp_samprate)
    sampling_period = np.median(time_diff)
    f, pxx = periodogram(ibi_ms, fs=1 / sampling_period)
    plt.figure(figsize=(10, 4))
    plt.semilogy(f, pxx)
    plt.title("Power Spectral Density of IBI (HRV Frequency Domain)")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Power")
    plt.grid(True)
    plt.show()

    # === 4. Poincaré plot (SD1–SD2 ellipse visualization) ===
    ibi_n = ibi_ms[:-1]
    ibi_n1 = ibi_ms[1:]
    mean_ibi = np.mean(ibi_ms)
    sd1 = float(bvp_features[16]) if isinstance(bvp_features, (list, tuple)) else bvp_features.get('sd1', np.nan)
    sd2 = float(bvp_features[17]) if isinstance(bvp_features, (list, tuple)) else bvp_features.get('sd2', np.nan)

    plt.figure(figsize=(5, 5))
    plt.scatter(ibi_n, ibi_n1, alpha=0.6)
    plt.title("Poincaré Plot (SD1 vs SD2)")
    plt.xlabel("IBI_n (s)")
    plt.ylabel("IBI_{n+1} (s)")
    circle = plt.Circle((mean_ibi, mean_ibi), sd2, color='r', fill=False, label=f"SD2={sd2:.4f}")
    plt.gca().add_artist(circle)
    circle2 = plt.Circle((mean_ibi, mean_ibi), sd1, color='g', fill=False, label=f"SD1={sd1:.4f}")
    plt.gca().add_artist(circle2)
    plt.legend()
    plt.grid(True)
    plt.axis('equal')
    plt.show()

    # === 5. DFA visualization (optional) ===
    if 'dfa_bvp' in bvp_features or (isinstance(bvp_features, (list, tuple)) and len(bvp_features) > 23):
        dfa = bvp_features[23] if isinstance(bvp_features, (list, tuple)) else bvp_features.get('dfa_bvp')
        plt.figure(figsize=(6, 4))
        plt.plot(
            np.log10(np.arange(1, len(bvp_raw)//10 + 1)),
            np.log10(minmax_scale(bvp_raw[:len(bvp_raw)//10])),
            'k.'
        )

        plt.title(f"DFA Visualization (α ≈ {dfa:.3f})")
        plt.xlabel("log(window size)")
        plt.ylabel("log(fluctuation)")
        plt.grid(True)
        plt.show()

    # === 6. Recurrence Plot (Optional Nonlinear Dynamics Visualization) ===
    try:
        from pyunicorn.timeseries import RecurrencePlot
        rp = RecurrencePlot(bvp_raw, dim=1, tau=1, eps=None, metric='euclidean')
        plt.figure(figsize=(5, 5))
        plt.imshow(rp.recurrence_matrix(), cmap='binary', origin='lower')
        plt.title("Recurrence Plot")
        plt.xlabel("Time")
        plt.ylabel("Time")
        plt.show()
    except Exception as e:
        print(f"Skipping recurrence plot (missing pyunicorn): {e}")

    # === 7. Print feature summary ===
    print("\n=== Extracted Features Summary ===")
    if isinstance(bvp_features, dict):
        for k, v in bvp_features.items():
            print(f"{k:<15}: {v:.6f}")
    else:
        print(bvp_features)


def BVP_features_extr(bvp_raw, bvp_samprate, window_size):
#     the list of available features is:
#           - mean_: averaged BVP - ralated to blood pressure
#           - HRV: heart rate variability calculated based on the standard deviation IBI differences
#           - meanIBI: mean heart rate (beat per minute)
#           - Frequency bands --> LF, HF and UHF
#               - sum, energy, ratio, norm and relative power
#           - sd2, sd1, lsd2, tsd1
#           - csv, mcsi, cvi
#           - DFA
#           - RQA analysis: rrate, det, lmax, ent, lam, tt
#           - correlationDimension

    features_bvp_names = {'mean_', 'HRV_sdnn','HRV_rmssd', 'meanIBI','sum_LF','sum_HF',
                     'sum_UHF','LF_energia','HF_energia','UHF_energia','Ratio_LFHF', 
                     'LFnorm','HFnorm','Rel_power_LF','Rel_power_HF','Rel_power_UHF',
                     'sd2','sd1','Lsd2','Tsd1','csi','mcsi','cvi', 'dfa_bvp', 'rrate', 'det', 
                     'lmax', 'ent', 'lam', 'tt', 'corDim'}
    bvp_features = {}
    
    logger.info("Extracting BVP characteristics")
    logger.debug("Longitud ventana: %d" , len(bvp_raw))

    #LINEAR FEATURES
    bvp_mean = np.mean(bvp_raw)
   
    bvp_raw = np.array(bvp_raw)
    
    # función de SCIPY para encontrar los picos
    peaks, _ = find_peaks(bvp_raw, distance=0.4 * bvp_samprate)
    peak_times = peaks / bvp_samprate
    ibi_ms = np.diff(peak_times)

    #09/05/2025 --> por ahora decidimos estas medidas
    ibi_ms_mean =  np.mean(ibi_ms)
    logging.debug("IBI with sicpy: %.8f", ibi_ms_mean)
    hrv_sdnn_value_ms = np.std(ibi_ms) # overall variability
    logging.debug("hrv_sdnn_value SCIPY: %.8f", hrv_sdnn_value_ms)
    hrv_rmssd_value_ms = np.sqrt(np.mean(np.diff(ibi_ms)**2))  # short-term variability
    logging.debug("hrv_rmssd_value SCIPY: %.8f", hrv_rmssd_value_ms)

    ##### FREQUENCY DOMAIN DATA
    #Nivel de energía de las bandas
    # Calculate sampling period for periodogram
    time_diff = np.diff(peak_times)
    if np.any(time_diff <= 0):
        raise ValueError("Time values must be strictly increasing.")

    sampling_period = np.median(time_diff)  # median avoids skewing from outliers (instead of mean)
    fs = 1 / sampling_period  # Sampling frequency
    #sampling_period = np.mean(np.diff(vector_pos))
    if sampling_period <= 0:
        raise ValueError("Invalid sampling period - non-increasing time values")

    f, fft_signal_HRV = periodogram(ibi_ms, fs=1/sampling_period)

    # Normalize FFT (handle potential division by zero)
    fft_sum = np.sum(fft_signal_HRV)
    fft_signal_HRV = fft_signal_HRV / fft_sum if fft_sum > 0 else np.zeros_like(fft_signal_HRV)

    # Get frequency bands
    lf_signal, hf_signal, uhf_signal = bandas_frec(fft_signal_HRV, f)

    # Calculate band sums (handle empty bands)
    lf_sum = np.sum(lf_signal) * 100 if lf_signal.size > 0 else 0.0
    hf_sum = np.sum(hf_signal) * 100 if hf_signal.size > 0 else 0.0
    uhf_sum = np.sum(uhf_signal) * 100 if uhf_signal.size > 0 else 0.0
    logging.debug("LF sum: %.8f", lf_sum)
    logging.debug("HF sum: %.8f", hf_sum)
    logging.debug("UHF sum: %.8f", uhf_sum)


    lf_energy = np.abs(safe_log(lf_sum))
    hf_energy = np.abs(safe_log(hf_sum))
    uhf_energy = np.abs(safe_log(uhf_sum))
    logging.debug("LF energy: %.8f", lf_energy)
    logging.debug("HF energy: %.8f", hf_energy)
    logging.debug("UHF energy: %.8f", uhf_energy)

    ratio_LFHF, lf_norm, hf_norm, rel_power_lf, rel_power_hf, rel_power_uhf = calculate_ratios_and_energies(lf_energy, hf_energy, uhf_energy) 
    logging.debug("Ratio LFHF: %.8f", ratio_LFHF)
    logging.debug("LF norm: %.8f", lf_norm)
    logging.debug("HF norm: %.8f", hf_norm)
    logging.debug("Rel power LF: %.8f", rel_power_lf)
    logging.debug("Rel power HF: %.8f", rel_power_hf)
    logging.debug("Rel power UHF: %.8f", rel_power_uhf)

    ### NON LINEAR FEATURES
    # Calcular SD2 -- long term variability
    sd2 = [(np.sqrt(2)/2) * (ibi_ms[i] + ibi_ms[i+1]) for i in range(len(ibi_ms) - 1)]
    sd2_value = np.std(sd2)
    logging.debug("SD2 value: %.8f", sd2_value)

    # Calcular SD1 -- short term variability
    sd1 = [(np.sqrt(2)/2) * (ibi_ms[i] - ibi_ms[i+1]) for i in range(len(ibi_ms) - 1)]
    sd1_value = np.std(sd1)
    logging.debug("SD1 value: %.8f", sd1_value)

    diff_RR = ibi_ms[:-1] - ibi_ms[1:]  # RR[i] - RR[i+1]
    sum_RR = ibi_ms[:-1] + ibi_ms[1:]   # RR[i] + RR[i+1]
    
    # Precompute constants
    sqrt2_over_2 = np.sqrt(2) / 2
    
    # Compute SD1 (short-term variability)
    sd1_terms = sqrt2_over_2 * diff_RR
    sd1_mean = np.mean(sd1_terms)
    SD1 = np.sqrt(np.mean((sd1_terms - sd1_mean) ** 2))
    logging.debug("SD1 value opt2: %.8f", SD1)
    
    # Compute SD2 (long-term variability)
    sd2_terms = sqrt2_over_2 * sum_RR
    sd2_mean = np.mean(sd2_terms)
    SD2 = np.sqrt(np.mean((sd2_terms - sd2_mean) ** 2))
    logging.debug("SD2 value opt2: %.8f", SD2)

    # Longitudinal factor as ref indicated
    lsd2 = 4 * sd2_value
    logging.debug("LSD2: %.8f", lsd2)

    # Transversal factor as ref indicated
    tsd1 = 4 * sd1_value
    logging.debug("TSD1: %.8f", tsd1)

    csi = SD2/sd1_value
    logging.debug("CSI: %.8f", csi)

    mcsi = lsd2**2 /tsd1
    logging.debug("MCSI: %.8f", mcsi)

    cvi = np.log10(lsd2*tsd1)
    logging.debug("CVI: %.8f", cvi)
    # Compute DFA
    rawSignal = decimate(bvp_raw, 4)
    #rawSignal = bvp_raw
    pts = np.arange(round(len(rawSignal)/10), len(rawSignal), 10)
    dfa_out, _ = DFA_fun(rawSignal, pts)
    dfa_bvp = dfa_out[0]
    logging.debug("DFA: %.8f", dfa_bvp)

    y = phase_space_reconstruction(rawSignal, max_lag=1, max_dim=3)
    x = cerecurr_y(y)

    #e_thr = 0.1 * np.mean(np.mean(x))*2
    e_thr = 0.1 * np.mean(x) * 2
    # black-white recurrence plot
    recurrpt = tdrecurr_y(x, e_thr)
    
    # Recurrence quantification analysis
    rqa = recurrqa_y(recurrpt)
    #print("RQA RESULTS: ", rqa)

    #rqa_3 = compute_rqa(rawSignal)

    rqa = recurrqa_y_2(recurrpt)
    #print("RQA RESULTS option 2: ", rqa)
    #print("RQA RESULTS option 3: ", rqa_3)
    #different way of obtaining the RQA analysis
    time_series = TimeSeries(rawSignal,
                            embedding_dimension=1,
                            time_delay=0)
    settings = Settings(time_series,
                        analysis_type=Classic,
                        neighbourhood=FixedRadius(e_thr),
                        similarity_measure=EuclideanMetric,
                        theiler_corrector=1)
    computation = RQAComputation.create(settings,
                                        verbose=False)
    result = computation.run()

    recurrence_rate = result.recurrence_rate
    determinism = result.determinism
    longest_diagonal_line = result.longest_diagonal_line
    entropy_diagonal_lines = result.entropy_diagonal_lines
    laminarity = result.laminarity
    trapping_time = result.trapping_time
    logging.debug("RR: %.8f", recurrence_rate)
    logging.debug("det: %.8f", determinism)
    logging.debug("lmax: %.8f", longest_diagonal_line)
    logging.debug("ent: %.8f", entropy_diagonal_lines)
    logging.debug("lam: %.8f", laminarity)
    logging.debug("tt: %.8f", trapping_time)

    
    # Correlation Dimension
    #corDim = correlationDimension(rawSignal, eLag, eDim, NumPoints=100)
    corr_dim = nolds.corr_dim(bvp_raw, emb_dim = 1)
    logging.debug("CorrDim: %.8f", corr_dim)


    bvp_features = (bvp_mean,hrv_sdnn_value_ms,hrv_rmssd_value_ms,ibi_ms_mean,lf_sum,
                hf_sum,uhf_sum, lf_energy,hf_energy, uhf_energy, 
                ratio_LFHF,lf_norm,hf_norm,rel_power_lf,rel_power_hf,
                rel_power_uhf,sd1_value, sd2_value,lsd2, tsd1, 
                csi, mcsi, cvi, dfa_bvp, recurrence_rate, 
                determinism, longest_diagonal_line, entropy_diagonal_lines, laminarity, trapping_time, corr_dim)

    return bvp_features, features_bvp_names

def decompose_eda(signal, sample_rate=1000):
    """
    Decompose EDA signal into tonic and phasic components
    
    Parameters:
        signal (array): Preprocessed GSR signal
        sample_rate (int): Sampling rate in Hz
    
    Returns:
        tonic (array): Tonic component
        phasic (array): Phasic component
    """
    # Simple moving average for tonic component (window of 5 seconds)
    window_size = 5 * sample_rate
    tonic = np.convolve(signal, np.ones(window_size)/window_size, mode='same')
    
    # Phasic component is the residual
    phasic = signal - tonic
    
    return tonic, phasic

def detect_peaks(phasic, sample_rate=1000, min_peak_height=0.1, min_peak_distance=1.0):
    """
    Detect peaks in the phasic component of EDA
    
    Parameters:
        phasic (array): Phasic component of GSR
        sample_rate (int): Sampling rate in Hz
        min_peak_height (float): Minimum height to be considered a peak (in standard deviations)
        min_peak_distance (float): Minimum distance between peaks (in seconds)
    
    Returns:
        peaks (array): Indices of detected peaks
        properties (dict): Peak properties
    """
    # Convert minimum peak distance from seconds to samples
    min_samples = int(min_peak_distance * sample_rate)
    
    # Find peaks
    peaks, properties = find_peaks(phasic, 
                                  height=min_peak_height, 
                                  distance=min_samples)
    
    return peaks, properties

def calculate_nsscr_metrics(phasic, peaks, sample_rate):
    """
    Calculate additional metrics for NS-SCRs
    
    Parameters:
        phasic (array): Phasic component of GSR
        peaks (array): Indices of detected peaks
        sample_rate (int): Sampling rate in Hz
    
    Returns:
        metrics (DataFrame): DataFrame containing NS-SCR metrics
    """
    metrics = {
        'peak_time': [],
        'amplitude': [],
        'rise_time': [],
        'recovery_time': []
    }
    
    for peak in peaks:
        # Find start of rise (where derivative becomes positive)
        deriv = np.diff(phasic[:peak])
        rise_start = np.where(deriv > 0.01)[0][-1]  # first point where derivative > threshold
        
        # Find end of recovery (where signal returns to near baseline)
        recovery_threshold = 0.1 * phasic[peak]  # 10% of peak amplitude
        recovery_end = peak + np.where(phasic[peak:] < recovery_threshold)[0][0]
        
        # Calculate metrics
        rise_time = (peak - rise_start) / sample_rate
        recovery_time = (recovery_end - peak) / sample_rate
        
        metrics['peak_time'].append(peak / sample_rate)
        metrics['amplitude'].append(phasic[peak])
        metrics['rise_time'].append(rise_time)
        metrics['recovery_time'].append(recovery_time)
    
    return pd.DataFrame(metrics)

from scipy.spatial.distance import pdist, squareform

#TESTING -- NOT DEFINITIVE
def grassberger_procaccia(signal, emb_dim=1, tau=1):
    # Time delay embedding
    N = len(signal) - (emb_dim - 1) * tau
    
    if N < 10:
        raise ValueError("Signal too short for embedding")
    
    embedded = np.array([signal[i:i + emb_dim * tau:tau] 
                         for i in range(N)])
    
    # Compute pairwise distances
    dists = squareform(pdist(embedded))
    
    # Remove self-distances (zeros on diagonal)
    np.fill_diagonal(dists, np.inf)
    
    # Get valid distance range (avoid zeros and outliers)
    valid_dists = dists[dists > 0]
    if len(valid_dists) == 0:
        return np.nan
    
    min_dist = np.percentile(valid_dists, 5)
    max_dist = np.percentile(valid_dists, 95)
    
    # Calculate correlation sum C(r) for various radii
    radii = np.logspace(np.log10(min_dist), 
                        np.log10(max_dist), 50)
    
    corr_sums = []
    for r in radii:
        count = (dists < r).sum()
        if count > 0:
            corr_sums.append(count / (N * (N - 1)))
        else:
            corr_sums.append(1e-10)  # Small value to avoid log(0)
    
    # Convert to arrays and remove invalid values
    corr_sums = np.array(corr_sums)
    
    # Filter out zeros and invalid values before log
    valid_mask = corr_sums > 0
    log_r = np.log(radii[valid_mask])
    log_c = np.log(corr_sums[valid_mask])
    
    # Need at least 2 points for polyfit
    if len(log_r) < 2:
        return np.nan
    
    # Use middle 60% of the scaling region for more stability
    start_idx = max(0, len(log_r) // 5)
    end_idx = min(len(log_r), 4 * len(log_r) // 5)
    
    if end_idx - start_idx < 2:
        return np.nan
    
    try:
        corr_dim = np.polyfit(log_r[start_idx:end_idx], 
                              log_c[start_idx:end_idx], 1)[0]
        return corr_dim
    except np.linalg.LinAlgError:
        return np.nan
def GSR_features_extr(gsr_raw, gsr_samprate, window_size):
#    the list of available features is:
#               - nbPeaks: number of GSR peaks per second
#               - ampPeaks: average amplitude of peaks
#               - riseTime: average rise time of peaks
#               - meanGSR: average GSR value
#               - stdGSR: variance of GSR
    features_gsr_names = {'nbPeaks', 'ampPeaks', 'riseTime', 'recoveryTime', 'aup', 'meanGSR',
                      'stdGSR','firstQuartileGSR','thirdQuartileGSR','sp0005','sp0515'}
    
    logging.info("Extractiong GSR characteristics")
    
    '''
    UNCOMMENT TO VISUALISE THE SIGNAL
    import matplotlib.pyplot as plt
    plt.plot(gsr_raw)
    plt.title("GSR Signal")
    plt.show()
    '''
    #de alvaro
    signals, info = nk.eda_process(gsr_raw, sampling_rate=gsr_samprate)

    peaks, _ = find_peaks(gsr_raw)
    logging.debug("GSR number of peaks option 2: %.8f", len(peaks))
    number_of_scr_peaks = len(info["SCR_Peaks"])
    logging.debug("GSR number of peaks: %.8f", number_of_scr_peaks)
    amp_peaks = np.mean(info["SCR_Amplitude"]) if info["SCR_Amplitude"].size > 0 else None
    logging.debug("GSR ampPeaks: %.8f", amp_peaks)
    rise_time_mean = np.mean(info["SCR_RiseTime"]) if info["SCR_RiseTime"].size > 0 else None
    logging.debug("GSR rise time: %.8f", rise_time_mean)

    scr_peaks = info['SCR_Peaks']
    recovtime = np.mean(np.nan_to_num(info["SCR_Recovery"], nan=0)) if np.nan_to_num(info["SCR_Recovery"], nan=0).size > 0 else None
    logging.debug("GSR recovery: %.8f", recovtime)

    peak_areas = []
    for peak_index in scr_peaks:
        start_index = max(0, peak_index - window_size)
        end_index = min(len(gsr_raw), peak_index + window_size)
        peak_signal = gsr_raw[start_index:end_index]
        time_window = np.arange(0, len(peak_signal))

        # Integrate using the trapezoidal rule
        area = np.trapz(peak_signal, x=time_window) #TODO: según la versión de python hay que usar trapz o trapezoid
        peak_areas.append(area)

    # Calculate metrics
    aup= (np.mean(peak_areas))
    logging.debug("GSR AUP: %.8f", aup)
   
    gsr_mean = np.mean(gsr_raw)
    logging.debug("GSR mean: %.8f", gsr_mean)
    gsr_std = np.std(gsr_raw)
    logging.debug("GSR std: %.8f", gsr_std)
    q1 = np.percentile(gsr_raw, 25)
    logging.debug("GSR Q1: %.8f", q1)
    q3 = np.percentile(gsr_raw, 75)
    logging.debug("GSR Q1: %.8f", q3)

    #Energy bands
    welch_window_size_GSR = len(gsr_raw) - gsr_samprate
    # Computing power spectral density using Welch's method
    f, P = welch(
        gsr_raw,             # Signal
        fs=gsr_samprate,                 # Sampling frequency
        window='hamming',      # MATLAB default is Hamming if only size is given
        nperseg=welch_window_size_GSR,           # Window size
        noverlap=welch_window_size_GSR/2,          # 50% overlap
        nfft=welch_window_size_GSR,              # FFT length
        detrend='constant',    # Remove mean (matches MATLAB)
        scaling='density',     # PSD (power per Hz)
        return_onesided=True   # Like MATLAB, for real input
    )
    
    # Normalize the power spectral density
    P /= np.sum(P)
    # Compute power spectral features
    sp0005 = np.log(np.sum(P[(f > 0.0) & (f <= 0.5)]) + np.finfo(float).eps)
    sp0515 = np.log(np.sum(P[(f > 0.5) & (f <= 1.5)]) + np.finfo(float).eps)
    sp_energyRatio = np.log(np.sum(P[f < 0.5]) / np.sum(P[(f > 0.5) & (f < 1.5)]) + np.finfo(float).eps)

    logging.debug("GSR sp0005: %.8f", sp0005)
    logging.debug("GSR sp0515: %.8f", sp0515)
    logging.debug("GSR energy ratio: %.8f", sp_energyRatio)
    # Compute DFA
    rawSignal = decimate(gsr_raw, 4)
    #rawSignal = bvp_raw
    pts = np.arange(round(len(rawSignal)/10), len(rawSignal), 10)
    dfa_out, _ = DFA_fun(rawSignal, pts)
    dfa_gsr = dfa_out[0]
    logging.debug("DFA GSR: %.8f", dfa_gsr)

    y = phase_space_reconstruction(rawSignal, max_lag=1, max_dim=3)
    x = cerecurr_y(y)

    e_thr = 0.1 * np.mean(x) * 2
    # black-white recurrence plot
    recurrpt = tdrecurr_y(x, e_thr)
    
    # Recurrence quantification analysis

    time_series = TimeSeries(rawSignal,
                            embedding_dimension=1,
                            time_delay=0)
    settings = Settings(time_series,
                        analysis_type=Classic,
                        neighbourhood=FixedRadius(e_thr),
                        similarity_measure=EuclideanMetric,
                        theiler_corrector=1)
    computation = RQAComputation.create(settings,
                                        verbose=False)
    result = computation.run()

    recurrence_rate = result.recurrence_rate
    determinism = result.determinism
    longest_diagonal_line = result.longest_diagonal_line
    entropy_diagonal_lines = result.entropy_diagonal_lines
    laminarity = result.laminarity
    trapping_time = result.trapping_time
    logging.debug("RR: %.8f", recurrence_rate)
    logging.debug("det: %.8f", determinism)
    logging.debug("lmax: %.8f", longest_diagonal_line)
    logging.debug("ent: %.8f", entropy_diagonal_lines)
    logging.debug("lam: %.8f", laminarity)
    logging.debug("tt: %.8f", trapping_time)

    
    # Correlation Dimension
    #corDim = correlationDimension(rawSignal, eLag, eDim, NumPoints=100)
    #corr_dim = nolds.corr_dim(gsr_raw, emb_dim = 1)

    # CorrInt implements correlation dimension estimation
    #COMPLICADO HACERLO FUNCIONAR, HAY QUE FORZAR MUCHO
    '''
    estimator = CorrInt()
    gsr_array = np.array(gsr_raw).reshape(-1, 1)
    corr_dim = estimator.fit(gsr_array).dimension_
    '''
    print("=== GSR Signal Diagnostics ===")
    print(f"Length: {len(gsr_raw)}")
    print(f"Min: {np.min(gsr_raw):.6f}")
    print(f"Max: {np.max(gsr_raw):.6f}")
    print(f"Mean: {np.mean(gsr_raw):.6f}")
    print(f"Std: {np.std(gsr_raw):.6f}")
    print(f"Range: {np.max(gsr_raw) - np.min(gsr_raw):.6f}")
    print(f"Unique values: {len(np.unique(gsr_raw))}")

    # Try with normalization
    gsr_norm = (gsr_raw - np.mean(gsr_raw)) / (np.std(gsr_raw) + 1e-8)

    try:
        cd = nolds.corr_dim(gsr_norm, emb_dim=2)
        sample_ent = nolds.sampen(gsr_raw)
        print(f"\nCorrelation Dimension (normalized): {cd}")
        print(f"\nSample Entropy: {sample_ent}")
    except Exception as e:
        print(f"\nError: {e}")
   # corr_dim = grassberger_procaccia(gsr_raw, emb_dim=1)
    logging.debug("CorrDim: %.8f", cd)
    
    gsr_features = (number_of_scr_peaks, amp_peaks,rise_time_mean, recovtime,aup,gsr_mean, gsr_std,
                    q1, q3, sp0005, sp0515,sp_energyRatio,dfa_gsr,recurrence_rate,determinism,longest_diagonal_line,entropy_diagonal_lines,
                    laminarity,trapping_time,cd)
 
    return gsr_features, features_gsr_names

def signal_feat_band_energy(signal, samprate, bands):

    # Welch window size
    welch_window_size = min(len(signal) - samprate, len(signal))
    f, P = welch(signal, fs=samprate, window='hamming', nperseg=int(welch_window_size), noverlap=None, nfft=None, return_onesided=True, scaling='density')
   # f, P = welch(signal, samprate, nperseg=int(welch_window_size))

    # Compute log-energy for each band
    power_bands = []
    f_0001_indices = np.where((f > 0.0) & (f <= 0.1))
    f_0102_indices = np.where((f > 0.1) & (f <= 0.2))

    # Calculate spectral power in specific frequency bands
    sp0001 = np.log(np.sum(P[f_0001_indices]) + np.finfo(float).eps)
    sp0102 = np.log(np.sum(P[f_0102_indices]) + np.finfo(float).eps)

    power_bands.append(sp0001)
    power_bands.append(sp0102)

    return power_bands


def band_power_fft(signal, fs, fmin, fmax):
  
    n = len(signal)
    # Apply window
    window = np.hamming(n)
    x_win = signal * window
    if(n < fs/0.1):
        logging.warning("skt signal is too short")
        # Compute FFT
    X = np.fft.fft(x_win, n)
    freqs = np.fft.fftfreq(n, d=1/fs)

    # Take only positive frequencies
    pos_mask = freqs >= 0
    freqs = freqs[pos_mask]
    X = X[pos_mask]

    # Compute Power Spectral Density
    # Normalize by window power and sampling rate to get PSD (power/Hz)
    U = np.sum(window**2)
    Pxx = (np.abs(X)**2) / (fs * U)
    freqs = np.fft.rfftfreq(n, d=1/fs)
    #fft_vals = np.fft.rfft(signal)
    #psd = np.abs(fft_vals)**2 / n  # Power Spectral Density

    # Find indices of the frequency band
    idx_band = np.where((freqs >= fmin) & (freqs <= fmax))

    # Integrate power within the band
    log_power = np.log(np.sum(Pxx[idx_band]) + np.finfo(float).eps)
    
    return log_power

def band_power_welch(signal, fs, fmin, fmax, nperseg=None):
    #comprobaciones del matlab
    welch_window_size = np.floor(len(signal)-fs)

    if fmin ==0: 
        fmin = 0.1

    if 1/fmin>welch_window_size/fs: 
        logging.warning('This welch window size is too small for your bands and the results are incorrect- consider increasing it')

    if len(signal)< welch_window_size +fs: 
        logging.warning('signal too short for the welch size')
    if len(signal)< welch_window_size +1: 
        logging.warning('signal too short for the welch size and this method will not work')

    #freqs, psd = welch(signal, fs=fs,window='hamming', nperseg=welch_window_size)
    freqs, psd = welch(
        signal,             # Signal
        fs=fs,                 # Sampling frequency
        window='hamming',      # MATLAB default is Hamming if only size is given
        nperseg=welch_window_size,           # Window size
        noverlap=welch_window_size/2,          # 50% overlap
        nfft=welch_window_size,              # FFT length
        detrend='constant',    # Remove mean (matches MATLAB)
        scaling='density',     # PSD (power per Hz)
        return_onesided=True   # Like MATLAB, for real input
    )
    psd /= np.sum(psd) #normalize signal
    idx_band = np.logical_and(freqs >= fmin, freqs <= fmax)
    band_power = np.log(np.sum(psd[idx_band]) + np.finfo(float).eps)
  
    return band_power

def SKT_features_extr(skt_raw, skt_samprate):
#    the list of available features is:
#               - mean_: average temprature
#               - std_: standard deviation of the temperature
#               - kurtosis_: Kurtosis of the temperature
#               - skewness_: skewness of the temperature
#               - sp0001: Spectral power 0-0.1Hz
#               - sp0102: Spectral power 0.1-0.2Hz
    features_skt_names = {'mean_', 'std_', 'kurtosis_','skewness_','sp0001', 'sp0102'}
    #LINEAR FEATURES
    logging.info("Extractiong SKT characteristics")
    skt_mean = np.mean(skt_raw)
    logging.debug("SKT mean: %.8f", skt_mean)
    skt_std = np.std(skt_raw)
    logging.debug("SKT std: %.8f", skt_std)
    skt_kurtosis = kurtosis(skt_raw, fisher=False)
    logging.debug("SKT kurtosis: %.8f", skt_kurtosis)
    skt_skewness = skew(skt_raw)
    logging.debug("SKT skewness: %.8f", skt_skewness)

    #FREQUENCY DOMAIN FEATURES
    # sale más adecuado con el FFT pero lo del welch es traducción literal del matlab

    sp0001_2 = band_power_fft(skt_raw, skt_samprate, 0, 0.1)
    sp0102_2 = band_power_fft(skt_raw, skt_samprate, 0.1, 0.2)
    sp0001_3 = band_power_welch(skt_raw, skt_samprate,0,0.1, nperseg=len(skt_raw))
    sp0102_3 = band_power_welch(skt_raw, skt_samprate,0.1,0.2, nperseg=len(skt_raw))
    logging.debug("SKT SP0001 FFT: %.8f", sp0001_2)
    logging.debug("SKT SP0102 FFT: %.8f", sp0102_2)
    logging.debug("SKT SP0001 welch: %.8f", sp0001_3)
    logging.debug("SKT SP0102 welch: %.8f", sp0102_3)


    skt_features = (skt_mean, skt_std, skt_kurtosis, skt_skewness, sp0001_3, sp0102_3)
    return skt_features, features_skt_names



def select_folder():
    # Create a Tkinter root window
    root = tk.Tk()
    # Hide the root window
    root.withdraw()
    # Open the folder selection dialog
    folder_path = filedialog.askdirectory(title="Select a Folder")
    # Print the selected folder path
    if folder_path:
        print(f"Selected folder: {folder_path}")
        return folder_path
    else:
        print("No folder selected.")
        return False
    
def read_psd_file(file_path):
    # Read the CSV file using pandas
    df = pd.read_csv(file_path, delimiter=';', skiprows=1)  # Skip the header row
    # Extract relevant columns
    timestamps = df['timestamp']
    skt_data = df['SKT']
    bvp_data = df['BVP']
    gsr_data = df['GSR']
    emg_data = df['EMG']
    resp_data = df['Resp']
    acc1_data = df['ACC1']
    acc2_data = df['ACC2']
    acc3_data = df['ACC3']
    
    # Return a dictionary of the signals for easier access
    signals_data = {
        'timestamps': timestamps,
        'skt_data': skt_data,
        'bvp_data': bvp_data,
        'gsr_data': gsr_data,
        'emg_data': emg_data,
        'resp_data': resp_data,
        'acc1_data': acc1_data,
        'acc2_data': acc2_data,
        'acc3_data': acc3_data
    }
    
    return signals_data

import subprocess

#Appends new features and sends back number of existing rows
def append_features_to_csv(csv_filename, all_features):
    file_exists = os.path.isfile(csv_filename)
    
    # Read existing rows (if any)
    existing_rows = []
    if file_exists:
        with open(csv_filename, 'r', newline='') as csvfile:
            reader = csv.reader(csvfile)
            existing_rows = list(reader)
    
    # Append new row
    with open(csv_filename, 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(all_features)
    
    # Return updated row count (existing + 1)
    return len(existing_rows) + 1

if __name__ == '__main__':
        logger.info("Starting program")
        data_type = 'Bindi' #sys.argv[1] #tipo de datos a procesar 'EH' o 'Bindi'
        overlap_csv = 0 #sys.argv[2] #porcentaje de overlap para sacar featureMAPS en el CSV
        video_files = []
        bvp_vector = []
        gsr_vector = []
        skt_vector = []
        folder_path = select_folder()
        csv_filename = "Testing_allWindows.csv"

        # definir el tamaño de la ventana y el solapamiento
        window_size = 24  # segundos
        overlap = 12  # segundos
        #1 - Seleccionar la carpeta con los datos de Bindi de la prueba de RV 
        #folder_path = select_folder()

        #REVISAR: quizá preferimos que se nos pase el archivo directamente
        if data_type == 'Bindi': #En el servidor solo procesamos datos de Bindi, no EH
            #Definimos frecuencias de muestreo
            samprate_bvp = 100
            samprate_gsr_initial = 10
            samprate_skt_initial = 5
            samprate_gsr = 5 #probar a 5 ausencia de errores QUIZÁ 5????
            samprate_skt = 5
            #CON LOS DATOS SIN PROCESAR NI NADA
            with open(f"{folder_path}.txt", "a") as file1:
                file1.write(f"Processing folder: {folder_path}")
            for file in os.listdir(folder_path):
                #PROBAR CON UN FICHERO CON TODAS LAS SEÑALES, COMPLETO
                if file.endswith(".txt"):
                    video_files.append(os.path.join(folder_path, file))
        
            if video_files == []:
                logger.error("No text Bindi to process")
                exit()
            else:
                logger.debug("Files to process: %s", len(video_files))
                signals = []
                #de aqui llamar al parser
                logger.debug("trying to access the following file: %s", folder_path)
                previousdata = None
                for video in video_files:
                    logger.info("Video file length is: %s", len(video))
                    signal_parser = parser_bindi.preprocess_folder(video, True, previousdata) #SE AÑADEN LAS SEÑALES O SE REESCRIBEN??? - creo que solo saca una ventana
                    previousdata = signal_parser
                    if signal_parser != "":
                        #signals.append(signal_parser) #definir buena forma para las señales para sacar los vectores
                        bvp_vector = signal_parser[0]
                        gsr_vector = signal_parser[1]
                        skt_vector=signal_parser[2]

                    #subprocess.run(["python", "parser_bindi.py", "preprocess_folder", folder_path, True])
        elif data_type == 'EH':
            #definimos frecuencias de muestreo 
            samprate_bvp = 200
            #GSR y SKT a 10Hz porque en el preprocesado se les ha hecho un downsample (de 200 a 10)
            samprate_gsr_initial = 200
            samprate_skt_initial = 200
            samprate_gsr = 10 
            samprate_skt = 10
            with open(f"{folder_path}.csv", "a") as file1:
                file1.write(f"Processing folder: {folder_path}")
            
            #llamar al autoparser
            autoParser_v2.main(folder_path)

            for file in os.listdir(folder_path):
                if file.endswith(".csv.psd") and "VVIDEO" in file:
                    video_files.append(os.path.join(folder_path, file))
            #Comprobamos
            if video_files == []:
                logger.error("No EH files to process")
            else:
                bvp_vector = []
                gsr_vector = []
                skt_vector = []
                for video in video_files:
                    signals_eh = read_psd_file(video)
                    bvp_vector.append(signals_eh['bvp_data'])
                    gsr_vector.append(signals_eh['gsr_data'])
                    skt_vector.append(signals_eh['skt_data'])
                #extraer las señales
            
        else:
            logger.error("Defined data type not correct")
            exit() #si el tipo de dato definido no es correcto salimos del programa


        #ESTO ESTARÍA DENTRO DE UN  BUCLE PARA CADA VOLUNTARIA Y VIDEO EN EL FORMATO MATLAB
        bvp_vector_file = bvp_vector
        gsr_vector_file = gsr_vector
        skt_vector_file = skt_vector

        start_bvp = 0
        stop_bvp = window_size * samprate_bvp
        start_gsr = 0
        stop_gsr = window_size * samprate_gsr
        start_skt = 0
        stop_skt = window_size * samprate_skt
        overlap_bvp = overlap * samprate_bvp
        overlap_gsr = overlap * samprate_gsr
        overlap_skt = overlap * samprate_skt
        window_num = 1
        bvp_sig_cpy = bvp_vector
        gsr_sig_cpy = gsr_vector
        skt_sig_cpy = skt_vector
        write = 1
        #TODO: 10 VENTANAS --> que llame al modelo
        #plantear solapamiento de las ventanas --> guardo 10 y luego con las 5 siguientes etc
        #calculo de metricas --> miro la etiqueta y compruebo con la de verdad
        logger.debug("Longitud BVP: %s while STOP is %s", len(bvp_vector_file), stop_bvp)
        logger.debug("Longitud GSR: %s while STOP is %s", len(gsr_vector_file), stop_gsr)
        logger.debug("Longitud SKT: %s while STOP is %s", len(skt_vector_file), stop_skt)
        #Filter the signal from each file
        bvp_vector_filtered = BVP_filter(bvp_vector_file,  samprate_bvp)
        gsr_vector_filtered = GSR_filter(gsr_vector_file, samprate_gsr_initial, data_type)
        skt_vector_filterd = SKT_filter(skt_vector_file, samprate_skt_initial, data_type)


        j = 0
        while stop_bvp <= len(bvp_vector_file) and stop_gsr <= len(gsr_vector_file) and stop_skt <= len(skt_vector_file):
            logger.info("Processing window %s", j)
            j+=1

            # BVP processing - call the function once per window
            bvp_sig_cpy = bvp_vector_file[start_bvp:stop_bvp]
            bvp_features, bvp_names = BVP_features_extr(bvp_sig_cpy,samprate_bvp,window_size)
            
            # Convert to dict for readability
            bvp_features_dict = dict(zip(bvp_names, bvp_features))
            debug_BVP_features(bvp_sig_cpy, samprate_bvp, bvp_features_dict)
            # GSR processing
            gsr_sig_cpy= gsr_vector_file[start_gsr:stop_gsr]
            gsr_features, gsr_names = GSR_features_extr(gsr_sig_cpy, samprate_gsr, window_size)

            #SKT processing
            #parece que funciona con las dos frecuencias de muestro (bindi y lab)
            skt_sig_cpy = skt_vector_file[start_skt:stop_skt]
            skt_features, skt_names = SKT_features_extr(skt_sig_cpy,samprate_skt)

            # If we want the names of the features written as headers
            #if(write == 1):
            #    header = bvp_names | gsr_names | skt_names
            #   #header = bvp_names + gsr_names + skt_names
            #  writer.writerow(header)
            # write = 0
            
            # Combine all features for this window
            all_features = bvp_features + gsr_features + skt_features
            total_rows = append_features_to_csv(csv_filename,all_features)

            # If we now have 10 rows, call example() with them
            if total_rows >= 10:
                if total_rows >= 10:
                    feature_file = './model/features.txt' #Save in the same place as the model - overwrite each time
                    with open(csv_filename, 'r', newline='') as csvfile:
                        reader = csv.reader(csvfile)
                        rows = list(reader)
                        feature_map = rows[:10]  # get first 10 rows

                    with open(feature_file, 'w') as f:
                        for row in feature_map:
                            f.write(','.join(str(item) for item in row) + '\n')

                    logger.info("Transmitting featureMap: %s", len(feature_map))
                    pred = deployment_model.main(feature_file)

                    #Remove from CSV unused rows that don't have to repear
                    logger.info("Rows to erase: %s", int(overlap_csv*10))
                    remaining_rows = rows[int(overlap_csv*10):]
                    with open(csv_filename, 'w', newline='') as csvfile:
                        writer = csv.writer(csvfile)
                        writer.writerows(remaining_rows)

            #Moving to the next window
            start_bvp += overlap_bvp
            stop_bvp += overlap_bvp
            start_gsr += overlap_gsr
            stop_gsr += overlap_gsr
            start_skt += overlap_skt
            stop_skt += overlap_skt
            window_num += 1