// This is the Hello, World example from "https://openexr.com/en/latest/HelloWorld.html"

#include <iostream>
#include <ImfRgbaFile.h>
#include <ImfArray.h>

std::string pixeltostring(Imf::Rgba pixel) {
    std::stringstream output;

    output << "r:" << pixel.r << " g:" << pixel.g << " b:" << pixel.b;
    return output.str();
}

// Imf::Array2D does not have a publicly accessible copy constructor so
// the array should be passed reference or as a constant reference
std::string printImage(Imf::Array2D<Imf::Rgba>& pixels, int width, int height) {
    std::stringstream output;
    output << "Image contents" << std::endl;
    for (int i=0; i < height; i++) {
        output << "i:" << i << std::endl;
        for (int j=0; j < width; j++) {
            output << "j:" << j << std::endl;
            output << pixeltostring(pixels[i][j]) << std::endl;
        }
    }
    return output.str();
}

int main() {
    std::cout << "read small file" << std::endl;

    try {
        Imf::RgbaInputFile file("hello.exr");
        Imath::Box2i dw = file.dataWindow();
        int width = dw.max.x - dw.min.x + 1;
        int height = dw.max.y - dw.min.y + 1;

        Imf::Array2D<Imf::Rgba> pixels(width, height);

        file.setFrameBuffer(&pixels[0][0], 1, width);
        file.readPixels(dw.min.y, dw.max.y);

        std::cout << printImage(pixels, width, height);
    } catch (const std::exception &e) {
        std::cerr << "error reading image file hello.exr:" << e.what() << std::endl;
        return 1;
    }

    return 0;
}
