// This is the Hello, World example from "https://openexr.com/en/latest/HelloWorld.html"

#include <iostream>
#include <ImfRgbaFile.h>
#include <ImfInputFile.h>
#include <ImathBox.h>
#include <ImfArray.h>

using namespace Imf;
using namespace Imath;

std::string pixeltostring(half pixel) {
    std::stringstream output;

    output << "r:" << pixel;
    return output.str();
}

// Imf::Array2D does not have a publicly accessible copy constructor so
// the array should be passed reference or as a constant reference
std::string printImage(Imf::Array2D<half>& pixels, int width, int height) {
    std::stringstream output;
    output << "Image contents" << std::endl;
    for (int i=0; i < height; i++) {
        for (int j=0; j < width; j++) {
            output << "<" << i << ", " << j << "> ";
            output << pixeltostring(pixels[i][j]) << std::endl;
        }
    }
    return output.str();
}

void readR(const char fname[], Array2D<half>& rPixels, int& width, int& height) {
    InputFile file(fname);
    Box2i dw = file.header().dataWindow();
    width = dw.max.x - dw.min.x + 1;
    height = dw.max.y - dw.min.y + 1;

    rPixels.resizeErase(height, width);

    FrameBuffer frameBuffer;

    frameBuffer.insert("R",
                       Slice(HALF,
                             (char*)(&rPixels[0][0] - dw.min.x - dw.min.y*width),
                             sizeof(rPixels[0][0]),
                             width*sizeof(rPixels[0][0]), 1, 1, 0.0));

    file.setFrameBuffer(frameBuffer);
    file.readPixels(dw.min.y, dw.max.y);
}

int main() {
    std::cout << "read small file" << std::endl;

    try {
//        Imf::RgbaInputFile file("hello.exr");
//        Imath::Box2i dw = file.dataWindow();
//        int width = dw.max.x - dw.min.x + 1;
//        int height = dw.max.y - dw.min.y + 1;

//        Imf::Array2D<Imf::Rgba> pixels(width, height);

//        file.setFrameBuffer(&pixels[0][0], 1, width);
//        file.readPixels(dw.min.y, dw.max.y);

        Array2D<half> pixels;
        int width, height;

        readR("potential.exr", pixels, width, height);
        std::cout << printImage(pixels, width, height);
    } catch (const std::exception &e) {
        std::cerr << "error reading image file hello.exr:" << e.what() << std::endl;
        return 1;
    }

    return 0;
}
