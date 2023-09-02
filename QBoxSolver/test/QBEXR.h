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

void writeR(const char fname[], const half* rPixels, int width, int height);
void writeRGB(const char fname[], const half* rPixels, const half* gPixels, const half* bPixels, int width, int height);
void readR(const char fname[], Imf::Array2D<half>& rPixels, int& width, int& height);
void readRGB(const char fname[], Imf::Array2D<half>& rPixels, Imf::Array2D<half>& gPixels, Imf::Array2D<half>& bPixels, int& width, int& height);

#endif // QBEXR_H_
