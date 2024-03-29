import numpy
import ctypes

from numpy.ctypeslib import ndpointer
lib = ctypes.cdll.LoadLibrary("./libQBEXR.so")

_writeR = lib.writeR
_writeR.restype = None
_writeR.argtypes = [ctypes.c_char_p,
                    ndpointer(ctypes.c_float, flags="C_CONTIGUOUS"),
                    ctypes.c_int,
                    ctypes.c_int]

_writeRGB = lib.writeRGB
_writeRGB.restype = None
_writeRGB.argtypes = [ctypes.c_char_p,
                      ndpointer(ctypes.c_float, flags="C_CONTIGUOUS"),
                      ctypes.c_int,
                      ctypes.c_int]

_readR = lib.readR
_readR.restype = ctypes.POINTER(ctypes.c_float)
_readR.argtypes = [ctypes.c_char_p,
                   ctypes.POINTER(ctypes.c_int),
                   ctypes.POINTER(ctypes.c_int)]

_readRGB = lib.readRGB
_readRGB.restype = ctypes.POINTER(ctypes.c_float)
_readRGB.argtypes = [ctypes.c_char_p,
                     ctypes.POINTER(ctypes.c_int),
                     ctypes.POINTER(ctypes.c_int)]

def writeR(fname, data):
    if (len(data.shape) != 2):
        raise ValueError("Data must have shape (n, m) repersenting a grayscale image.")
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = data.astype(ctypes.c_float)
    height, width = data.shape
    data = data.flatten()
    _writeR(fname, data, width, height)

def writeRGB(fname, data):
    if ((len(data.shape) != 3) or (data.shape[-1] != 3)):
        raise ValueError("Data must have shape (n, m, 3) repersenting a RGB image.")
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = data.astype(ctypes.c_float)
    height, width, channels = data.shape
    rgbdata = data.flatten()
    _writeRGB(fname, rgbdata, width, height)

def readR(fname):
    width, height = ctypes.c_int(), ctypes.c_int()
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = _readR(fname, ctypes.byref(width), ctypes.byref(height))
    width, height = width.value, height.value

    data = ctypes.cast(data, ctypes.POINTER(ctypes.c_float*(width*height)))[0]
    return numpy.frombuffer(data, ctypes.c_float).reshape(height, width)

def readRGB(fname):
    width, height = ctypes.c_int(), ctypes.c_int()
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = _readRGB(fname, ctypes.byref(width), ctypes.byref(height))
    width, height = width.value, height.value

    data = ctypes.cast(data, ctypes.POINTER(ctypes.c_float*(width*height*3)))[0]
    return numpy.frombuffer(data, ctypes.c_float).reshape(height, width, 3)
