"""
Load QBox simulation data and save in a format sutable for Unity.
"""

#temporaily use QBox from POC to load data.
import QBox

import json
import numpy
import imageio
import warnings

def _sRGBtoLinearRGB(data):
    warnings.warn("sRGB to linear RGB conversion is using the aproximation gamma=2.2", stacklevel=2)
    return numpy.power(data, 2.2)

class QBoxConvert:
    _EXR_ZIP = 4 # freeimage library flag: EXR_ZIP 4
    _CHANNELS = 3 # RGBA
    _VALID_CHANNELS = [1, 3, 4] # R RGB RGBA

    def __init__(self, path_pk, title, path_data = ".", isLinearMode=True):
        self.path_pk = path_pk
        self.title = title
        self.path_data = path_data
        self.isLinearMode = isLinearMode
        self.qboxsolver = None
        self.config_data = {}

    def save(self):
        self.qboxsolver = QBox.QBox(1,1,self.path_pk) # default QBox
        self.qboxsolver.load()

        self.config_data = {}
        self._save_potential()
        self._save_states()
        self._save_json()

    def _save_json(self):
        self.config_data["numberOfStates"] = len(self.qboxsolver.States)
        self.config_data["resolution"] = self.qboxsolver.res
        self.config_data["xMax"] = self.qboxsolver.x_max
        self.config_data["energyLevels"] = self.qboxsolver.Energy_levels
        self.config_data["isLinear"] = self.isLinearMode
        with open(self.path_data + "/" + self.title + "_config.json", "w") as fout:
            json.dump(self.config_data, fout, indent=4)

    def _save_potential(self):
        data = numpy.reshape(self.qboxsolver.V, (1,) + self.qboxsolver.V.shape)
        data_max, data_min = numpy.max(data), numpy.min(data)
        data = data - data_min
        data = data/(data_max - data_min)
        data = data*2 - 1
        self._save_EXR(data, "potential", numChannels=1)

        self.config_data["potentialMax"] = data_max
        self.config_data["potentialMin"] = data_min

    def _save_states(self):
        self._save_EXR(numpy.array(self.qboxsolver.States), "states", numChannels=self._CHANNELS)

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
        imageio.imwrite(image_path + ".exr", data, format="exr", flags=self._EXR_ZIP)

    def _pack_EXR(self, data, postfix, numChannels=4):
        if numChannels not in self._VALID_CHANNELS:
            raise ValueError("Error: number of channels must be one of " + ", ".join(self._VALID_CHANNELS) + ".")

        # ------------------------ IMPROVE PACKING -----------------------
        num_images = int(numpy.ceil(len(data)/numChannels))
        resolution = self.qboxsolver.res
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
