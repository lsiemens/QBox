using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// WaveFunction contains all the the nessisary information to describe a quantum
// superposition and methods to get its time evelution.
public class WaveFunction : MonoBehaviour
{
    [System.NonSerialized] public int numberOfStates;
    float[,] coefficients; // {{real part, imaginary part}, ...}
    private float _expectedEnergy;

    QuantumSystem quantumSystem;
    private static WaveFunction waveFunction;

    public static float expectedEnergy {
        get {
            return instance._expectedEnergy;
        }
    }

    public static int NumberOfStates {
        get {
            return instance.numberOfStates;
        }
    }

    private static WaveFunction instance {
        get {
            if (!waveFunction) {
                waveFunction = FindObjectOfType(typeof(WaveFunction)) as WaveFunction;
                if (!waveFunction) {
                    Debug.LogError("No active WaveFunction component found.");
                }
            }
            return waveFunction;
        }
    }

    public static void Reload() {
        QSystemController.Reload();
        instance.Initalize();
    }

    void Initalize() {
        Debug.Log("Initalize WaveFunction");
        updateQuantumSystem();
        coefficients = new float[numberOfStates, 2];
    }

    void updateQuantumSystem() {
        quantumSystem = QSystemController.currentQuantumSystem;
        numberOfStates = quantumSystem.numberOfStates;
    }

    public static void SetCoefficients(float[,] newCoeffiecients) {
        instance.coefficients = newCoeffiecients;
        instance._expectedEnergy = instance.GetExpectedEnergy();
    }

    public static void UpdateRender(float time=0.0f) {
        // --------------------------- NEEDS TO BE VALIDATED -------------
        int k = 0;
        Color[] realData = new Color[instance.quantumSystem.maxTextureLayer];
        Color[] imaginaryData = new Color[instance.quantumSystem.maxTextureLayer];
        for (int i = 0; i < instance.quantumSystem.maxTextureLayer; i++) {
            for (int j = 0; j < instance.quantumSystem.stateChannels; j++) {
                k = j + i*instance.quantumSystem.stateChannels;
                float cos_et = Mathf.Cos(instance.quantumSystem.energyLevels[k]*time);
                float sin_et = Mathf.Sin(instance.quantumSystem.energyLevels[k]*time);
                realData[i][j] = instance.coefficients[k, 0]*cos_et - instance.coefficients[k, 1]*sin_et;
                imaginaryData[i][j] = instance.coefficients[k, 1]*cos_et + instance.coefficients[k, 0]*sin_et;
            }
        }

        MaterialController.currentMaterial.SetColorArray("_RealCoefficients", realData);
        MaterialController.currentMaterial.SetColorArray("_ImaginaryCoefficients", imaginaryData);
    }

    private float GetExpectedEnergy() {
        float energy = 0.0f;
        int k = 0;
        for (int i = 0; i < instance.quantumSystem.maxTextureLayer; i++) {
            for (int j = 0; j < instance.quantumSystem.stateChannels; j++) {
                k = j + i*instance.quantumSystem.stateChannels;
                energy += (Mathf.Pow(instance.coefficients[k, 0], 2) + Mathf.Pow(instance.coefficients[k, 1], 2))*instance.quantumSystem.energyLevels[k];
            }
        }
        return energy;
    }

}
