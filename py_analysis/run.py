# -*- coding: utf-8 -*-
import wave
import numpy as np

from scipy.io.wavfile import read
import scipy.signal

from levinson_durbin import autocorr, LevinsonDurbin

# set wav file
path_read = "test3.wav"

def wavread(filename):
    wf = wave.open(filename, "r")
    fr = wf.getframerate()
    nf = wf.getnframes()
    x = wf.readframes(wf.getnframes())
    x = np.frombuffer(x, dtype="int16") / 327680.0 # (-1, 1) normalizer
    wf.close()
    return x, float(fr), nf

def pre_emphasis(signal, p):
    """プリエンファシスフィルタ"""
    # 係数 (1.0, -p) のFIRフィルタを作成
    return scipy.signal.lfilter([1.0, -p], 1, signal)

def get_formant(lst, fr):
    p = 0.97
    s = pre_emphasis(lst, p)
    # s = lst
    
    hammingWindow = np.hamming(len(s))
    s = s * hammingWindow
    lpcOrder = 32
    r = autocorr(s, lpcOrder + 1)

    a, e = LevinsonDurbin(r, lpcOrder)

    # LPC係数の振幅スペクトルを求める
    nfft = 2048   # FFTのサンプル数
    fscale = np.fft.fftfreq(nfft, d = 1.0 / fr)[:nfft/2]
    # オリジナル信号の対数スペクトル
    spec = np.abs(np.fft.fft(s, nfft))
    logspec = 20 * np.log10(spec)
    # LPC対数スペクトル
    w, h = scipy.signal.freqz(np.sqrt(e), a, nfft, "whole")
    lpcspec = np.abs(h)
    loglpcspec = 20 * np.log10(lpcspec)

    lst_lls = loglpcspec[:nfft/2]
    lst_f = []
    for i in range(len(lst_lls)):
        if (0 == i - len(lst_lls) + 1):
            return 0, 0
        if (0 < 2 - i):
            continue
        if 0 < lst_lls[i] - lst_lls[i-1] and 0 < lst_lls[i] - lst_lls[i+1]:
            lst_f.append(fscale[i])

            if (0 == len(lst_f) - 2):
                return lst_f[0], lst_f[1]
        
    return 0, 0

def vowel(f1, f2):

    F1_A = [800, 1150]
    F2_A = [800, 1800]
    F1_I = [250, 700]
    F2_I = [1200, 3500]
    F1_U = [250, 510]
    F2_U = [1000, 2000]
    F1_E = [500, 800]
    F2_E = [1400, 2800]
    F1_O = [230, 800]
    F2_O = [800, 1400]

    lst_walk = [[F1_A, F2_A],[F1_I, F2_I],[F1_U, F2_U],[F1_E, F2_E],[F1_O, F2_O]]

    lst_vowel = ["あ", "い", "う", "え", "お"]
    lst_matcher = []
    for lst in lst_walk:
        if 0 < f1 - lst[0][0] and 0 > f1 - lst[0][1] and\
           0 < f2 - lst[1][0] and 0 > f2 - lst[1][1]:
            center = np.array([(lst[0][1] + lst[0][0]) / 2 , (lst[1][1] + lst[1][0]) / 2])
            datum = np.array([f1, f2])
            edge = np.array([lst[0][0], lst[1][0]])
            u = datum - center
            u = np.linalg.norm(u)
            l = edge - center
            l = np.linalg.norm(l)
            
            weight = u / l
            lst_matcher.append(weight)
        else:
            lst_matcher.append(100)

    i = np.argmin(lst_matcher)
    return i


spec_all, fr, nf = wavread("res/sound/{}".format(path_read))

print("res/sound/{}".format(path_read))
i = 0
frame_all = fr
time_all = float(nf / fr)

cnt = 0
flg = False
lst_timing = []
lst_split_spec = []
lst = []

for spec in spec_all:
    i += 1
    lst.append(spec)
    if ( 0 != spec ):
        if ( flg == False ):
            cnt += 1
            msec_calc = i / frame_all * time_all
            lst_timing.append( round(msec_calc, 5) )
            lst_split_spec.append(lst)
            lst = []
        flg = True
    else:
        flg = False

time_cut = 1 / 30
n_all_window = int(time_all / time_cut)

lst = []
print(len(lst_split_spec))
for i in range( n_all_window ):
    time_cut_start = i * time_cut * fr
    time_cut_end = ( i + 1 ) * time_cut * fr
    spec = spec_all[ time_cut_start : time_cut_end]
    if (0 == len(spec)):
        lst.append(-1)
        continue
    
    if (np.all(0 == spec)):
        lst.append(-1)
        continue

    f1, f2 = get_formant(spec, fr)

    i_vowel = vowel(f1, f2)
    lst.append(i_vowel)

with open("out/{}.conf".format(path_read), "w") as f:
    line = ",".join(str(v) for v in lst)

    f.writelines(line) 
    f.close()

print("done")
