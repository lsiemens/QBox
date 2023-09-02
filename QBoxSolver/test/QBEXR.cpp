// QBox EXR data
//
// Defines functions for reading and writing QBox data to EXR files.
//
// The HDF5 created by these routines should have the folowing structure

//
// file_name : file
//     |
//     run_name : HDF5 Group
//        |
//        maxNumberOfStates, numberOfStates : Integer HDF5 Attribute
//        resolution, numberOfGrids : Integer HDF5 Attribute
//        length, mass, targetEvolutionTime : Real HDF5 Attribute
//        isPeriodicBoundary : Logical HDF5 Attribute
//        states : 3D HDF5 Dataset
//        potential : 2D HDF5 Dataset
//        energyLevels : 1D HDF5 Dataset

#include "QBEXR.h"

void writeR(const char fname[], const half* rPixels, int width, int height) {
    Imf::Header header(width, height);
    header.channels().insert("R", Imf::Channel(Imf::HALF));
    Imf::OutputFile file(fname, header);

    Imf::FrameBuffer frameBuffer;
    frameBuffer.insert("R", Imf::Slice(Imf::HALF, (char*) rPixels, sizeof(*rPixels), width*sizeof(*rPixels)));
    file.setFrameBuffer(frameBuffer);
    file.writePixels(height);
}

void writeRGB(const char fname[], const half* rPixels, const half* gPixels, const half* bPixels, int width, int height) {
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

void readR(const char fname[], Imf::Array2D<half>& rPixels, int& width, int& height) {
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

void readRGB(const char fname[], Imf::Array2D<half>& rPixels, Imf::Array2D<half>& gPixels, Imf::Array2D<half>& bPixels, int& width, int& height) {
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
