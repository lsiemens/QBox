using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystem contains all the nessisary information to describe a Quantum
[CreateAssetMenu(menuName = "QBox/Quantum Objects/QuantumSystem")]
public class QuantumSystem : ScriptableObject {
    public TextAsset systemConfig;
    public Texture2D potentialTextureEXR;
    public Texture2D statesTextureEXR;

    [System.NonSerialized] public int stateChannels;
    [System.NonSerialized] public int maxTextureLayer;
    [System.NonSerialized] public int numberOfStates;
    int resolution;
    float[,,] states; // states[level, i, j]
    [System.NonSerialized] public float[] energyLevels;
    Texture2D potentialTexture;
    Texture2DArray statesTexture;

// ------------------------------ TEMPORARY
    public float Norm2(float[,] data) {
        float dx = 0.1f; // Get from ImportData
        if ((data.GetLength(0) != resolution) || (data.GetLength(1) != resolution)) {
            Debug.LogError("function must have dimensions resolution X resolution");
        }
        float value = 0.0f;
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                value += data[i, j]*data[i, j]*dx*dx;
            }
        }
        return value;
    }

// ---------------------------------- TEMPORARY
    public float[,] MakeGaussian(float width) {
        float[,] coefficients = new float[numberOfStates, 2];
        float[,] gaussian = new float[resolution, resolution];
        float dx = 0.1f;
        float x, y;
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                x = (j - resolution/2 + 0)*dx;
                y = (i - resolution/2 - 64)*dx;
                gaussian[i, j] = Mathf.Exp(-(x*x + y*y)/(width*width));
            }
        }
        float norm = Mathf.Sqrt(Norm2(gaussian));
        /*for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                gaussian[i, j] = gaussian[i, j]/norm;
            }
        }*/

        for (int k = 0; k < numberOfStates; k++) {
            float value = 0.0f;
            /*for (int i = 0; i < resolution; i++) {
                for (int j = 0; j < resolution; j++) {
                    value += states[k, i, j]*states[k, i, j]*dx*dx;
                }
            }
            norm = Mathf.Sqrt(value);
            for (int i = 0; i < resolution; i++) {
                for (int j = 0; j < resolution; j++) {
                    states[k, i, j] = states[k, i, j]/norm;
                }
            }*/

            value = 0.0f;
            for (int i = 0; i < resolution; i++) {
                for (int j = 0; j < resolution; j++) {
                    value += states[k, i, j]*gaussian[i, j]*dx*dx; //*gaussian[i, j]
                }
            }
            coefficients[k, 0] = value;

        }
        float value1 = 0.0f;
        for (int k = 0; k < numberOfStates; k++) {
            value1 += coefficients[k, 0]*coefficients[k, 0] + coefficients[k, 1]*coefficients[k, 1];
        }
        value1 = Mathf.Sqrt(value1);
        for (int k = 0; k < numberOfStates; k++) {
            coefficients[k, 0] /= value1;
            coefficients[k, 1] /= value1;
        }

        return coefficients;
    }

    public void Load() {
        // ------------------ CONFIGURATION DATA ---------------------------------
        Debug.Log("Loading Quantum System Configuration.");
        ImportData importData = JsonUtility.FromJson<ImportData>(systemConfig.ToString());
        numberOfStates = importData.numberOfStates;
        energyLevels = new float[numberOfStates];
        for (int i=0; i < numberOfStates; i++) {
            energyLevels[i] = (float)importData.energyLevels[i];
        }
        resolution = importData.resolution;
        stateChannels = importData.statesAtlasChannels;

        // ------------------- POTENTAL ----------------------------
        potentialTexture = new Texture2D(resolution, resolution, TextureFormat.RFloat, false);
        Color[] textureData = potentialTextureEXR.GetPixels(0);

        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                for (int k = 0; k < importData.potentialAtlasChannels; k++) {
                    textureData[j + i*resolution][k] = 0.5f*(1.0f + Mathf.Log(textureData[j + i*resolution][k]));
                }
            }
        }
        potentialTexture.SetPixels(textureData, 0);
        potentialTexture.Apply();
        MaterialController.currentMaterial.SetTexture("_MainTex", potentialTexture);

        // ------------------- STATES ----------------------------
        // load state data to states
        textureData = statesTextureEXR.GetPixels(0);

        int stateIndex = 0;

        states = new float[numberOfStates, resolution, resolution];
        for (int grid_i = importData.statesAtlasGrid - 1; grid_i >= 0; grid_i--) {
            for (int grid_j = 0; grid_j < importData.statesAtlasGrid; grid_j++) {
                for (int grid_c = 0; grid_c < stateChannels; grid_c++) {

                    for (int pixel_i = 0; pixel_i < resolution; pixel_i++) {
                        for (int pixel_j = 0; pixel_j < resolution; pixel_j++) {
                            states[stateIndex, pixel_i, pixel_j] = Mathf.Log(textureData[pixel_j + resolution*(grid_j + importData.statesAtlasGrid*(pixel_i + grid_i*resolution))][grid_c]);
                        }
                    }

                    stateIndex++;
                    if (stateIndex >= numberOfStates) break; // cascading breaks
                }
                if (stateIndex >= numberOfStates) break; // cascading breaks
            }
            if (stateIndex >= numberOfStates) break; // cascading breaks
        }

        if (numberOfStates % stateChannels != 0) {
            Debug.LogError("Error: " + numberOfStates + " quantum states can not fit into an integer number of " + importData.statesAtlasChannels + " channel textures.");
        }

        maxTextureLayer = numberOfStates / stateChannels;
        statesTexture = new Texture2DArray(resolution, resolution, maxTextureLayer, TextureFormat.RGBAFloat, false);
        for (int layer = 0; layer < maxTextureLayer; layer++) {
            Color[] tempState = new Color[resolution*resolution];

            for (int i = 0; i < resolution; i++) {
                for (int j = 0; j < resolution; j++) {
                    for (int k = 0; k < stateChannels; k++) {
                        tempState[j + i*resolution][k] = states[k + layer*stateChannels, i, j];
                    }
                }
            }

            statesTexture.SetPixels(tempState, layer);
        }
        statesTexture.Apply();
        MaterialController.currentMaterial.SetTexture("_States", statesTexture);
        MaterialController.currentMaterial.SetInt("_MaxIndex", maxTextureLayer);
        Debug.Log("Texture Loaded!");
    }
}
