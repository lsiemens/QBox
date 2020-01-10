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
    private UnityAction OnRaiseStateAction;
    private UnityAction OnLowerStateAction;

    private delegate void MethodPointer();
    private MethodPointer ContextPreupdate;

    private int viewStateIndex;

    void Awake() {
        OnStateMachineTransitionAction = new UnityAction(OnStateMachineTransition);
        OnRaiseStateAction = new UnityAction(OnRaiseState);
        OnLowerStateAction = new UnityAction(OnLowerState);
    }

    void OnEnable() {
        EventManager.RegisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
        EventManager.RegisterListener("Raise State", OnRaiseStateAction);
        EventManager.RegisterListener("Lower State", OnLowerStateAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
        EventManager.DeregisterListener("Raise State", OnRaiseStateAction);
        EventManager.DeregisterListener("Lower State", OnLowerStateAction);
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

    void ViewUpdate() {
        for (int i = 0; i < numberOfStates; i++) {
            coefficients[i, 0] = 0.0f;
            coefficients[i, 1] = 0.0f;
            if (i == viewStateIndex) {
                coefficients[i, 0] = 1.0f;
            }
        }
    }

    void EditUpdate() {
        Debug.Log(InputManager.mousePosition);
        coefficients = quantumSystem.MakeGaussian(InputManager.mousePosition, 0.5f*(Mathf.Cos(Time.time) + 1.01f));
    }

    void RunUpdate() {
        time += Time.deltaTime;
    }

    void OnStateMachineTransition() {
        viewStateIndex = 0;
        time = 0.0f;
        ContextPreupdate = null;
        string state = ProgramStateMachine.state;
        switch (state) {
            case "View":
                //ViewUpdate need only be called periodicaly when somthing changes
                ViewUpdate();
                break;
            case "Edit":
                ContextPreupdate = EditUpdate;
                break;
            case "Run":
                ContextPreupdate = RunUpdate;
                break;
            default:
                Debug.Log("WaveFunction, OnStateMachineTransition: unhandled transition, state: " + state);
                break;
        }
    }

    void OnRaiseState() {
        Debug.Log("Raising state");
        if (viewStateIndex + 1 < numberOfStates) {
            viewStateIndex++;
        }
        ViewUpdate();
    }

    void OnLowerState(){
        if (viewStateIndex > 0) {
            viewStateIndex--;
        }
        ViewUpdate();
    }
}
