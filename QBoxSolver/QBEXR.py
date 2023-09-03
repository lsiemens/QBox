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
    rdata = data[:, :, 0].flatten()
    gdata = data[:, :, 1].flatten()
    bdata = data[:, :, 2].flatten()
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

from matplotlib import pyplot

b = 2
width = 100
height = b*100
x = numpy.linspace(-3, 3, width)
y = numpy.linspace(-3*b, 3*b, height)
X, Y = numpy.meshgrid(x, y)
print(X.shape, " is ", (height, width))

data = numpy.exp(-(X**2 + Y**2))
cdata = numpy.empty((height, width, 3))
cdata[:, :, 0] = numpy.exp(-(X**2 + Y**2))
cdata[:, :, 1] = numpy.exp(-((X - 1)**2 + Y**2)*4)
cdata[:, :, 2] = numpy.exp(-(X**2 + (Y + 1)**2)*9)

pyplot.imshow(cdata)
pyplot.show()

writeR("gaussian.exr", data)
writeRGB("cgaussian.exr", cdata)

data2 = readR("gaussian.exr")
pyplot.imshow(data2)
pyplot.show()

cdata2 = readRGB("cgaussian.exr")
pyplot.imshow(cdata2)
pyplot.show()
