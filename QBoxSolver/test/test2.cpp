#include <iostream>

#include "QBEXR.h"
#include <cmath>

int main() {
    std::cout << "reproduce files" << std::endl;
    int width;
    int height;
    Imf::Array2D<half> rpixels(0, 0);

    try {
        readR("TestR.exr", rpixels, width, height);
    } catch (const std::exception &e) {
        std::cerr << "error reading image file: " << e.what() << std::endl;
        return 1;
    }

    try {
        writeR("TestR2.exr", &rpixels[0][0], width, height);
    } catch (const std::exception &e) {
        std::cerr << "error writting image file: " << e.what() << std::endl;
        return 1;
    }

    Imf::Array2D<half> gpixels(0, 0);
    Imf::Array2D<half> bpixels(0, 0);
    try {
        readRGB("TestRGB.exr", rpixels, gpixels, bpixels, width, height);
    } catch (const std::exception &e) {
        std::cerr << "error reading rgb image file: " << e.what() << std::endl;
        return 1;
    }

    try {
        writeRGB("TestRGB2.exr", &rpixels[0][0], &gpixels[0][0], &bpixels[0][0], width, height);
    } catch (const std::exception &e) {
        std::cerr << "error writting rgb image file: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}
