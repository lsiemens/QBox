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
                      ndpointer(ctypes.c_float, flags="C_CONTIGUOUS"),
                      ndpointer(ctypes.c_float, flags="C_CONTIGUOUS"),
                      ctypes.c_int,
                      ctypes.c_int]

_readR = lib.readR
#_readR.restype = ndpointer(ctypes.c_float, flags="C_CONTIGUOUS")
_readR.restype = ctypes.POINTER(ctypes.c_float)
_readR.argtypes = [ctypes.c_char_p,
                   ctypes.POINTER(ctypes.c_int),
                   ctypes.POINTER(ctypes.c_int)]

_readRGB = lib.readRGB
#_readRGB.restype = ndpointer(ctypes.c_float, flags="C_CONTIGUOUS")
_readRGB.restype = ctypes.POINTER(ctypes.c_float)
_readRGB.argtypes = [ctypes.c_char_p,
                     ctypes.POINTER(ctypes.c_int),
                     ctypes.POINTER(ctypes.c_int)]

def writeR(fname, data):
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = data.astype(ctypes.c_float)
    width, height = data.shape
    _writeR(fname, data, width, height)

def writeRGB(fname, data):
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = data.astype(ctypes.c_float)
    width, height, channels = data.shape
    if channels != 3:
        raise TypeError("Data must be a 2D array of RGB data")
    rdata = data[:, :, 0].flatten()
    gdata = data[:, :, 1].flatten()
    bdata = data[:, :, 2].flatten()
#    bdata = numpy.ascontiguousarray(data[:, :, 2])
    _writeRGB(fname, rdata, gdata, bdata, width, height)

def readR(fname):
    width, height = ctypes.c_int(), ctypes.c_int()
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = _readR(fname, ctypes.byref(width), ctypes.byref(height))
    width, height = width.value, height.value

    data = ctypes.cast(data, ctypes.POINTER(ctypes.c_float*(width*height)))[0]
    return numpy.frombuffer(data, ctypes.c_float).reshape(width, height)

def readRGB(fname):
    width, height = ctypes.c_int(), ctypes.c_int()
    fname = ctypes.c_char_p(fname.encode("ascii"))
    data = _readRGB(fname, ctypes.byref(width), ctypes.byref(height))
    width, height = width.value, height.value

    data = ctypes.cast(data, ctypes.POINTER(ctypes.c_float*(width*height*3)))[0]
    return numpy.frombuffer(data, ctypes.c_float).reshape(width, height, 3)

size = 200
x = numpy.linspace(-3, 3, size)
X, Y = numpy.meshgrid(x, x)

data = numpy.exp(-(X**2 + Y**2))
cdata = numpy.empty((size, size, 3))
cdata[:, :, 0] = numpy.exp(-(X**2 + Y**2))
cdata[:, :, 1] = numpy.exp(-((X - 1)**2 + Y**2))
cdata[:, :, 2] = numpy.exp(-(X**2 + (Y + 1)**2))

writeR("gaussian.exr", data)
writeRGB("cgaussian.exr", cdata)

from matplotlib import pyplot

data2 = readR("gaussian.exr")
pyplot.imshow(data2)
pyplot.show()

cdata2 = readRGB("cgaussian.exr")
pyplot.imshow(cdata2)
pyplot.show()
