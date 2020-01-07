using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// WaveFunction contains all the the nessisary information to describe a quantum
// superposition and methods to get its time evelution.
public class WaveFunction : MonoBehaviour
{
    public QuantumSystem quantumSystem;

    public Material mat;

    int numberOfStates;
    public float[,] coefficients; // {{real part, imaginary part}, ...}
    public float speed;

    // Start is called before the first frame update
    void Start()
    {
        speed = 0.1f;
        numberOfStates = quantumSystem.numberOfStates;
        coefficients = new float[numberOfStates, 2];
        for (int i = 0; i < numberOfStates; i++) {
            coefficients[i, 0] = 0.0f;
            coefficients[i, 1] = 0.0f;
        }
        coefficients[0,0] = 1.0f;
    }

    // Update is called once per frame
    void Update()
    {
        // --------------------------- NEEDS TO BE VALIDATED -------------
        int k = 0;
        Color[] realData = new Color[quantumSystem.maxTextureLayer];
        Color[] imaginaryData = new Color[quantumSystem.maxTextureLayer];
        for (int i = 0; i < quantumSystem.maxTextureLayer; i++) {
            for (int j = 0; j < quantumSystem.stateChannels; j++) {
                k = j + i*quantumSystem.stateChannels;
                float cos_et = Mathf.Cos(quantumSystem.energyLevels[k]*Time.time*speed);
                float sin_et = Mathf.Sin(quantumSystem.energyLevels[k]*Time.time*speed);
                realData[i][j] = coefficients[k, 0]*cos_et - coefficients[k, 1]*sin_et;
                imaginaryData[i][j] = coefficients[k, 1]*cos_et + coefficients[k, 0]*sin_et;
            }
        }
        mat.SetColorArray("_RealCoefficients", realData);
        mat.SetColorArray("_ImaginaryCoefficients", imaginaryData);
//        Color[] T = new Color[1023];
//        for (int i=0; i<1023; i++) {
//            T[i] = new Color(Mathf.Cos(i*3.14f/100.0f), Mathf.Sin(i*3.14f/100.0f), 0.0f, 0.0f);
//        }
//        mat.SetColorArray("_Test", T);
    }
}
