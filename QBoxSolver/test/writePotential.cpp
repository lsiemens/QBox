// Test writing 16bit RGB files for QBox, based on
// "Using the General Interface for Scan Line Based Files"
// in "https://openexr.com/en/latest/ReadingAndWritingImageFiles.html".

#include <iostream>
#include <ImfRgbaFile.h>
#include <ImfOutputFile.h>
#include <ImfChannelList.h>
#include <ImfArray.h>

using namespace Imf;

void writeR(const char fname[], const half* rPixels, int width, int height) {
    Header header(width, height);
    header.channels().insert("R", Channel(HALF));
    OutputFile file(fname, header);
    FrameBuffer frameBuffer;

    frameBuffer.insert("R",
                       Slice(HALF,
                             (char*) rPixels, sizeof(*rPixels),
                             width*sizeof(*rPixels)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
}

int main() {
    std::cout << "Make small file" << std::endl;
    int width = 10;
    int height = 10;

//    Imf::Array2D<Imf::Rgba> pixels(width, height);
    Imf::Array2D<half> pixels(width, height);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
//            pixels[y][x] = Imf::Rgba(0, x/(width - 1.0f), y/(height - 1.0f));
            pixels[y][x] = half(x/(width - 1.0f) + y/(height - 1.0f));
        }
    }

    try {
        writeR("potential.exr", &pixels[0][0], width, height);
//        Imf::RgbaOutputFile file("hello.exr", width, height, Imf::WRITE_RGBA);
//        file.setFrameBuffer(&pixels[0][0], 1, width);
//        file.writePixels(height);
    } catch (const std::exception &e) {
        std::cerr << "error writing image file hello.exr:" << e.what() << std::endl;
        return 1;
    }
    return 0;
}
