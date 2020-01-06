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
    _CHANNELS = 4 # RGBA

    def __init__(self, path_pk, title, path_data = ".", isLinearMode=True):
        self.path_pk = path_pk
        self.title = title
        self.path_data = path_data
        self.isLinearMode = isLinearMode
        self.qboxsolver = None

    def save(self):
        self.qboxsolver = QBox.QBox(1,1,self.path_pk) # default QBox
        self.qboxsolver.load()

        self._save_potential()
        self._save_states()
        self._save_json()

    def _save_json(self):
        data = {}
        data["numberOfStates"] = len(self.qboxsolver.States)
        data["energyLevels"] = self.qboxsolver.Energy_levels
        data["isLinear"] = self.isLinearMode
        with open(self.path_data + "/" + self.title + "_config.json", "w") as fout:
            json.dump(data, fout, indent=4)

    def _save_potential(self):
        data = numpy.reshape(self.qboxsolver.V, (1,) + self.qboxsolver.V.shape)
        data -= numpy.min(data)
        data /= numpy.max(data)
        data = data*2 - 1
        self._save_EXR(data, "potential")

    def _save_states(self):
        self._save_EXR(numpy.array(self.qboxsolver.States), "states")

    def _save_EXR(self, data, postfix):
        image_path = self.path_data + "/" + self.title + "_" + postfix
        data = self._pack_EXR(data)
        print(numpy.max(data))
        data = numpy.exp(data)
        print(numpy.max(data))
        if not self.isLinearMode:
            data = _sRGBtoLinearRGB(data)
            image_path += "_GAMMA"

        data = data.astype(numpy.float32)
        imageio.imwrite(image_path + ".exr", data, format="exr", flags=self._EXR_ZIP)

    def _pack_EXR(self, data):
        # ------------------------ IMPROVE PACKING -----------------------
        num_images = int(numpy.ceil(len(data)/self._CHANNELS))
        resolution = self.qboxsolver.res
        image_grid_dimension = int(numpy.ceil(numpy.sqrt(num_images)))
        image_resolution = image_grid_dimension*resolution

        data_packed = numpy.zeros(self._CHANNELS*image_resolution**2)
        data_packed[:len(data.ravel())] = data.ravel()

        data_packed = numpy.reshape(data_packed, (image_grid_dimension, image_grid_dimension, self._CHANNELS, resolution, resolution))
        data_packed = numpy.moveaxis(data_packed, [1, 2], [-3, -1])
        data_packed = numpy.reshape(data_packed, (image_resolution, image_resolution, self._CHANNELS))

        return data_packed
