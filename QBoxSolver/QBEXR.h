#ifndef QBEXR_H_
#define QBEXR_H_

#include <iostream>

#include <ImfInputFile.h>
#include <ImfOutputFile.h>
#include <ImfRgbaFile.h>
#include <ImfChannelList.h>
#include <ImfArray.h>
#include <ImfRgba.h>
#include <ImathBox.h>

extern "C" void writeR(const char fname[], const float* rPixels, int width, int height);
extern "C" void writeRGB(const char fname[], const float* rgbPixels, int width, int height);
extern "C" float* readR(const char fname[], int& width, int& height);
extern "C" float* readRGB(const char fname[], int& width, int& height);

#endif // QBEXR_H_
