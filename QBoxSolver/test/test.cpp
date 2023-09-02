#include <iostream>

#include "QBEXR.h"
#include <cmath>

int main() {
    std::cout << "make small file" << std::endl;
    int width = 6144;
    int height = 6144;
    int Num = 50;

    Imf::Array2D<half> rpixels(width, height);
    Imf::Array2D<half> gpixels(width, height);
    Imf::Array2D<half> bpixels(width, height);
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            rpixels[y][x] = half(x/(width - 1.0f) + y/(height - 1.0f));
            gpixels[y][x] = half(std::cos(2*3.14*Num*x/(width - 1.0f)));
            bpixels[y][x] = half(std::cos(2*3.24*Num*y/(height -1.0f)));
        }
    }

    try {
        writeRGB("TestRGB.exr", &rpixels[0][0], &gpixels[0][0], &bpixels[0][0], width, height);
    } catch (const std::exception &e) {
        std::cerr << "error writeing image file: " << e.what() << std::endl;
        return 1;
    }

    Imf::Array2D<half> rpixels2(width, height);
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            rpixels2[y][x] = half(x/(width - 1.0f) + y/(height - 1.0f));
        }
    }

    try {
        writeR("TestR.exr", &rpixels2[0][0], width, height);
    } catch (const std::exception &e) {
        std::cerr << "error writeing image file2: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}
