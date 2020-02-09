using System.Collections;
using System.Collections.Generic;

public struct ImportData
{
    public int potentialAtlasResolution, potentialAtlasGrid, potentialAtlasChannels;
    public double potentialMax, potentialMin;

    public int statesAtlasResolution, statesAtlasGrid, statesAtlasChannels;

    public int numberOfStates, resolution;
    public double length;
    public bool isLinear;
    public double[] energyLevels;
}
