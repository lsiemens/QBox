// QBox EXR data
//
// Defines functions for reading and writing QBox data to EXR files.

#include "QBEXR.h"

extern "C" void writeR(const char* fname, const float* rPixels, int width, int height) {
    half* rPixels_half = new half[width*height];
    for (int i=0; i < width*height; i++) {
        rPixels_half[i] = half(rPixels[i]);
    }

    Imf::Header header(width, height);
    header.channels().insert("R", Imf::Channel(Imf::HALF));
    Imf::OutputFile file(fname, header);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                       (char*) rPixels_half,
                                       sizeof(*rPixels_half),
                                       width*sizeof(*rPixels_half)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
    delete[] rPixels_half;
}

extern "C" void writeRGB(const char* fname, const float* rgbPixels, int width, int height) {
    half* rPixels_half = new half[width*height];
    half* gPixels_half = new half[width*height];
    half* bPixels_half = new half[width*height];
    for (int i=0; i < width*height; i++) {
        rPixels_half[i] = half(rgbPixels[0 + 3*i]);
        gPixels_half[i] = half(rgbPixels[1 + 3*i]);
        bPixels_half[i] = half(rgbPixels[2 + 3*i]);
    }

    Imf::Header header(width, height);
    header.channels().insert("R", Imf::Channel(Imf::HALF));
    header.channels().insert("G", Imf::Channel(Imf::HALF));
    header.channels().insert("B", Imf::Channel(Imf::HALF));
    Imf::OutputFile file(fname, header);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                       (char*) rPixels_half,
                                       sizeof(*rPixels_half),
                                       width*sizeof(*rPixels_half)));
    frameBuffer.insert("G", Imf::Slice(Imf::HALF,
                                       (char*) gPixels_half,
                                       sizeof(*gPixels_half),
                                       width*sizeof(*gPixels_half)));
    frameBuffer.insert("B", Imf::Slice(Imf::HALF,
                                       (char*) bPixels_half,
                                       sizeof(*bPixels_half),
                                       width*sizeof(*bPixels_half)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
    delete[] rPixels_half;
    delete[] gPixels_half;
    delete[] bPixels_half;
}

extern "C" float* readR(const char fname[], int& width, int& height) {
    Imf::InputFile file(fname);
    Imath::Box2i dataWindow = file.header().dataWindow();
    width = dataWindow.max.x - dataWindow.min.x + 1;
    height = dataWindow.max.y - dataWindow.min.y + 1;

    half* rPixels_half = new half[width*height];

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                  (char*)(rPixels_half - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(rPixels_half[0]),
                                  width*sizeof(rPixels_half[0]), 1, 1, 0.0));
    file.setFrameBuffer(frameBuffer);
    file.readPixels(dataWindow.min.y, dataWindow.max.y);

    float* rPixels = new float[width*height];
    for (int i=0; i < width*height; i++) {
        rPixels[i] = float(rPixels_half[i]);
    }
    delete[] rPixels_half;

    return rPixels;
}

extern "C" float* readRGB(const char fname[], int& width, int& height) {
    Imf::InputFile file(fname);
    Imath::Box2i dataWindow = file.header().dataWindow();
    width = dataWindow.max.x - dataWindow.min.x + 1;
    height = dataWindow.max.y - dataWindow.min.y + 1;

    half* rPixels_half = new half[width*height];
    half* gPixels_half = new half[width*height];
    half* bPixels_half = new half[width*height];

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF,
                                  (char*)(rPixels_half - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(rPixels_half[0]),
                                  width*sizeof(rPixels_half[0]), 1, 1, 0.0));
    frameBuffer.insert("G", Imf::Slice(Imf::HALF,
                                  (char*)(gPixels_half - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(gPixels_half[0]),
                                  width*sizeof(gPixels_half[0]), 1, 1, 0.0));
    frameBuffer.insert("B", Imf::Slice(Imf::HALF,
                                  (char*)(bPixels_half - dataWindow.min.x - dataWindow.min.y*width),
                                  sizeof(bPixels_half[0]),
                                  width*sizeof(bPixels_half[0]), 1, 1, 0.0));
    file.setFrameBuffer(frameBuffer);
    file.readPixels(dataWindow.min.y, dataWindow.max.y);

    float* rgbPixels = new float[3*width*height];
    for (int i=0; i < width*height; i++) {
        rgbPixels[0 + 3*i] = float(rPixels_half[i]);
        rgbPixels[1 + 3*i] = float(gPixels_half[i]);
        rgbPixels[2 + 3*i] = float(bPixels_half[i]);
    }
    delete[] rPixels_half;
    delete[] gPixels_half;
    delete[] bPixels_half;

    return rgbPixels;
}
