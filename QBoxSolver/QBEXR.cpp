// QBox EXR data
//
// Defines functions for reading and writing QBox data to EXR files.

#include "QBEXR.h"

extern "C" void writeR(const char* fname, const float* rPixels, int width, int height) {
    half* rPixels_half = new half[width*height];
    for (int i=0; i < width*height; i++) {
        rPixels_half[i] = half(rPixels[i]);
    }
    _writeR(fname, rPixels_half, width, height);
}

extern "C" void writeRGB(const char* fname, const float* rPixels, const float* gPixels, const float* bPixels, int width, int height) {
    half* rPixels_half = new half[width*height];
    half* gPixels_half = new half[width*height];
    half* bPixels_half = new half[width*height];
    for (int i=0; i < width*height; i++) {
        rPixels_half[i] = half(rPixels[i]);
        gPixels_half[i] = half(gPixels[i]);
        bPixels_half[i] = half(bPixels[i]);
    }
    _writeRGB(fname, rPixels_half, gPixels_half, bPixels_half, width, height);
}

extern "C" float* readR(const char* fname, int& width, int& height) {
    Imf::Array2D<half> rPixels_half(0, 0);
    _readR(fname, rPixels_half, width, height);
    float* rPixels = new float[width*height];
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            rPixels[y + x*width] = half(rPixels_half[y][x]);
        }
    }
    return rPixels;
}

extern "C" float* readRGB(const char* fname, int& width, int& height) {
    Imf::Array2D<half> rPixels_half(0, 0);
    Imf::Array2D<half> gPixels_half(0, 0);
    Imf::Array2D<half> bPixels_half(0, 0);
    _readRGB(fname, rPixels_half, gPixels_half, bPixels_half, width, height);
    float* rgbPixels = new float[width*height*3];
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            rgbPixels[0 + 3*(y + x*width)] = half(rPixels_half[y][x]);
            rgbPixels[1 + 3*(y + x*width)] = half(gPixels_half[y][x]);
            rgbPixels[2 + 3*(y + x*width)] = half(bPixels_half[y][x]);
        }
    }
    return rgbPixels;
}

void _writeR(const char fname[], const half* rPixels, int width, int height) {
    Imf::Header header(width, height);
    header.channels().insert("R", Imf::Channel(Imf::HALF));
    Imf::OutputFile file(fname, header);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF, (char*) rPixels, sizeof(*rPixels), width*sizeof(*rPixels)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
}

void _writeRGB(const char fname[], const half* rPixels, const half* gPixels, const half* bPixels, int width, int height) {
    Imf::Header header(width, height);
    header.channels().insert("R", Imf::Channel(Imf::HALF));
    header.channels().insert("G", Imf::Channel(Imf::HALF));
    header.channels().insert("B", Imf::Channel(Imf::HALF));
    Imf::OutputFile file(fname, header);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF, (char*) rPixels, sizeof(*rPixels), width*sizeof(*rPixels)));
    frameBuffer.insert("G", Imf::Slice(Imf::HALF, (char*) gPixels, sizeof(*gPixels), width*sizeof(*gPixels)));
    frameBuffer.insert("B", Imf::Slice(Imf::HALF, (char*) bPixels, sizeof(*bPixels), width*sizeof(*bPixels)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
}

void _readR(const char fname[], Imf::Array2D<half>& rPixels, int& width, int& height) {
    Imf::InputFile file(fname);
    Imath::Box2i dataWindow = file.header().dataWindow();
    width = dataWindow.max.x - dataWindow.min.x + 1;
    height = dataWindow.max.y - dataWindow.min.y + 1;
    rPixels.resizeErase(height, width);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                  (char*)(&rPixels[0][0] - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(rPixels[0][0]),
                                  width*sizeof(rPixels[0][0]), 1, 1, 0.0));
    file.setFrameBuffer(frameBuffer);
    file.readPixels(dataWindow.min.y, dataWindow.max.y);
}

void _readRGB(const char fname[], Imf::Array2D<half>& rPixels, Imf::Array2D<half>& gPixels, Imf::Array2D<half>& bPixels, int& width, int& height) {
    Imf::InputFile file(fname);
    Imath::Box2i dataWindow = file.header().dataWindow();
    width = dataWindow.max.x - dataWindow.min.x + 1;
    height = dataWindow.max.y - dataWindow.min.y + 1;
    rPixels.resizeErase(height, width);
    gPixels.resizeErase(height, width);
    bPixels.resizeErase(height, width);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                  (char*)(&rPixels[0][0] - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(rPixels[0][0]),
                                  width*sizeof(rPixels[0][0]), 1, 1, 0.0));
    frameBuffer.insert("G", Imf::Slice(Imf::HALF,
                                  (char*)(&gPixels[0][0] - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(gPixels[0][0]),
                                  width*sizeof(gPixels[0][0]), 1, 1, 0.0));
    frameBuffer.insert("B", Imf::Slice(Imf::HALF,
                                  (char*)(&bPixels[0][0] - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(bPixels[0][0]),
                                  width*sizeof(bPixels[0][0]), 1, 1, 0.0));
    file.setFrameBuffer(frameBuffer);
    file.readPixels(dataWindow.min.y, dataWindow.max.y);
}
