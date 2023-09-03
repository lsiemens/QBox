#!/usr/bin/env python3

"""
Usage:
  QBoxConvert.py HDF5 NAME [--path=PATH] [options]
  QBoxConvert.py -h | --help

Load QBox simulation data and save in a format sutable for Unity.

Arguments:
  HDF5      path to HDF5 file containing QBox data
  NAME      name of the data set. Creates files NAME_potential.exr NAME_states.exr NAME_config.json
  PATH      destination path

Options:
  -v --verbose      give verbose output
  -h --help         display this help and exit
  --path=PATH       spesify path to output files

"""

import docopt
import h5py
import json
import numpy
import warnings

import QBHD
import QBEXR

def _sRGBtoLinearRGB(data):
    warnings.warn("sRGB to linear RGB conversion is using the aproximation gamma=2.2", stacklevel=2)
    return numpy.power(data, 2.2)

class QBoxConvert:
    _EXR_ZIP = 4 # freeimage library flag: EXR_ZIP 4
    _CHANNELS = 3 # RGBA
    _VALID_CHANNELS = [1, 3] # R RGB RGBA

    def __init__(self, path_h5, title, path_data = ".", isLinearMode=True):
        self.path_h5 = path_h5
        self.title = title
        self.path_data = path_data
        self.isLinearMode = isLinearMode
        self.h5data = None
        self.config_data = {}

    def save(self, verbose=False):
        if verbose:
            print("WARNING: verbose output not implemented yet.")

        self.h5data = QBHD.load(self.path_h5)

        self.config_data = {}
        self._save_potential()
        self._save_states()
        self._save_json()

    def _save_json(self):
        self.config_data["numberOfStates"] = int(self.h5data.numberOfStates)
        self.config_data["resolution"] = int(self.h5data.resolution)
        self.config_data["length"] = float(self.h5data.length)
        self.config_data["mass"] = float(self.h5data.mass)
        self.config_data["energyLevels"] = list(self.h5data.energyLevels)
        self.config_data["isLinear"] = self.isLinearMode
        with open(self.path_data + "/" + self.title + "_config.json", "w") as fout:
            json.dump(self.config_data, fout, indent=4)

    def _save_potential(self):
        data = numpy.reshape(self.h5data.potential, (1, self.h5data.resolution, self.h5data.resolution))
        data_max, data_min = numpy.max(data), numpy.min(data)
        data = data - data_min
        data = data/(data_max - data_min)
        data = data*2 - 1
        self._save_EXR(data, "potential", numChannels=1)

        self.config_data["potentialMax"] = data_max
        self.config_data["potentialMin"] = data_min

    def _save_states(self):
        states = numpy.transpose(self.h5data.states, (2, 0, 1)) # reorder indices due to diffrence betwean fortran and C
        self._save_EXR(states, "states", numChannels=self._CHANNELS)

    def _save_EXR(self, data, postfix, numChannels=4):
        if numChannels not in self._VALID_CHANNELS:
            raise ValueError("Error: number of channels must be one of " + ", ".join(self._VALID_CHANNELS) + ".")

        image_path = self.path_data + "/" + self.title + "_" + postfix
        data = self._pack_EXR(data, postfix, numChannels)
        data = numpy.exp(data)
        if not self.isLinearMode:
            data = _sRGBtoLinearRGB(data)
            image_path += "_GAMMA"

        data = data.astype(numpy.float32)
        print(data.shape)
        if numChannels == 1:
            QBEXR.writeR(image_path + ".exr", data[:, :, 0])
        elif numChannels == 3:
            QBEXR.writeRGB(image_path + ".exr", data)

    def _pack_EXR(self, data, postfix, numChannels=4):
        if numChannels not in self._VALID_CHANNELS:
            raise ValueError("Error: number of channels must be one of " + ", ".join(self._VALID_CHANNELS) + ".")

        # ------------------------ IMPROVE PACKING -----------------------
        num_images = int(numpy.ceil(len(data)/numChannels))
        resolution = int(self.h5data.resolution)
        image_grid_dimension = int(numpy.ceil(numpy.sqrt(num_images)))
        image_resolution = image_grid_dimension*resolution

        data_packed = numpy.zeros(numChannels*image_resolution**2)
        data_packed[:len(data.ravel())] = data.ravel()

        data_packed = numpy.reshape(data_packed, (image_grid_dimension, image_grid_dimension, numChannels, resolution, resolution))
        data_packed = numpy.moveaxis(data_packed, [1, 2], [-3, -1])
        data_packed = numpy.reshape(data_packed, (image_resolution, image_resolution, numChannels))

        self.config_data[postfix + "AtlasResolution"] = image_resolution
        self.config_data[postfix + "AtlasGrid"] = image_grid_dimension
        self.config_data[postfix + "AtlasChannels"] = numChannels

        return data_packed

if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    path_h5 = arguments["HDF5"]
    name = arguments["NAME"]
    verbose = arguments["--verbose"]
    path = arguments["--path"]

    if path is None:
        path = "."

    converter = QBoxConvert(path_h5, name, path_data=path)
    converter.save(verbose)

