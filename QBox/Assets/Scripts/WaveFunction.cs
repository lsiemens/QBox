using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

// WaveFunction contains all the the nessisary information to describe a quantum
// superposition and methods to get its time evelution.
public class WaveFunction : MonoBehaviour
{
    int numberOfStates;
    public float[,] coefficients; // {{real part, imaginary part}, ...}
    public float speed;
    private float time;

    QuantumSystem quantumSystem;
    private UnityAction OnStateMachineTransitionAction;

    private delegate void MethodPointer();
    private MethodPointer ContextPreupdate;

    void Awake() {
        OnStateMachineTransitionAction = new UnityAction(OnStateMachineTransition);
    }

    void OnEnable() {
        EventManager.RegisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void Start()
    {
        updateQuantumSystem();
        coefficients = new float[numberOfStates, 2];
        OnStateMachineTransition();
    }

    void updateQuantumSystem() {
        quantumSystem = QSystemController.currentQuantumSystem;
        numberOfStates = quantumSystem.numberOfStates;
    }

    void Update()
    {
        if (ContextPreupdate != null) {
            ContextPreupdate();
        }
        // --------------------------- NEEDS TO BE VALIDATED -------------
        int k = 0;
        Color[] realData = new Color[quantumSystem.maxTextureLayer];
        Color[] imaginaryData = new Color[quantumSystem.maxTextureLayer];
        for (int i = 0; i < quantumSystem.maxTextureLayer; i++) {
            for (int j = 0; j < quantumSystem.stateChannels; j++) {
                k = j + i*quantumSystem.stateChannels;
                float cos_et = Mathf.Cos(quantumSystem.energyLevels[k]*time*speed);
                float sin_et = Mathf.Sin(quantumSystem.energyLevels[k]*time*speed);
                realData[i][j] = coefficients[k, 0]*cos_et - coefficients[k, 1]*sin_et;
                imaginaryData[i][j] = coefficients[k, 1]*cos_et + coefficients[k, 0]*sin_et;
            }
        }

        MaterialController.currentMaterial.SetColorArray("_RealCoefficients", realData);
        MaterialController.currentMaterial.SetColorArray("_ImaginaryCoefficients", imaginaryData);
    }

    void EditUpdate() {
        coefficients = quantumSystem.MakeGaussian(3.0f*(Mathf.Cos(Time.time) + 1.01f));
    }

    void RunUpdate() {
        time += Time.deltaTime;
    }

    void OnStateMachineTransition() {
        time = 0.0f;
        ContextPreupdate = null;
        string state = ProgramStateMachine.state;
        switch (state) {
            case "View":
                Debug.Log("view");
                for (int i = 0; i < numberOfStates; i++) {
                    coefficients[i, 0] = 0.0f;
                    coefficients[i, 1] = 0.0f;
                }
                coefficients[0,0] = 1.0f;
                break;
            case "Edit":
                for (int i = 0; i < numberOfStates; i++) {
                    coefficients[i, 0] = 0.0f;
                    coefficients[i, 1] = 0.0f;
                }
                ContextPreupdate = EditUpdate;
                break;
            case "Run":
                //coefficients = quantumSystem.MakeGaussian(3.0f);
                ContextPreupdate = RunUpdate;
                break;
            default:
                Debug.Log("WaveFunction, OnStateMachineTransition: unhandled transition, state: " + state);
                break;
        }
    }
}
