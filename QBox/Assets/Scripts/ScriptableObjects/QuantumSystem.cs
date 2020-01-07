using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystem contains all the nessisary information to describe a Quantum
[CreateAssetMenu(menuName = "QBox/Quantum Objects/QuantumSystem")]
public class QuantumSystem : ScriptableObject {
    public TextAsset systemConfig;
    public Texture2D potentialTextureEXR;
    public Texture2D statesTextureEXR;

    public Material mat;

    int maxTextureLayer;
    int numberOfStates;
    int resolution;
    float[,,] states; // states[level, i, j]
    float[] energyLevels;
    Texture2D potentialTexture;
    Texture2DArray statesTexture;

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
        mat.SetTexture("_Potential", potentialTexture);

        // ------------------- STATES ----------------------------
        // load state data to states
        textureData = statesTextureEXR.GetPixels(0);

        int stateIndex = 0;

        states = new float[numberOfStates, resolution, resolution];
        for (int grid_i = importData.statesAtlasGrid - 1; grid_i >= 0; grid_i--) {
            for (int grid_j = 0; grid_j < importData.statesAtlasGrid; grid_j++) {
                for (int grid_c = 0; grid_c < importData.statesAtlasChannels; grid_c++) {

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

        if (numberOfStates % importData.statesAtlasChannels != 0) {
            Debug.LogError("Error: " + numberOfStates + " quantum states can not fit into an integer number of " + importData.statesAtlasChannels + " channel textures.");
        }

        maxTextureLayer = numberOfStates / importData.statesAtlasChannels;
        statesTexture = new Texture2DArray(resolution, resolution, maxTextureLayer, TextureFormat.RGBAFloat, false);
        for (int layer = 0; layer < maxTextureLayer; layer++) {
            Color[] tempState = new Color[resolution*resolution];

            for (int i = 0; i < resolution; i++) {
                for (int j = 0; j < resolution; j++) {
                    for (int k = 0; k < importData.statesAtlasChannels; k++) {
                        tempState[j + i*resolution][k] = states[k + layer*importData.statesAtlasChannels, i, j];
                    }
                }
            }

            statesTexture.SetPixels(tempState, layer);
        }
        statesTexture.Apply();
        mat.SetTexture("_States", statesTexture);
        Debug.Log("Texture Loaded!");
    }
}
