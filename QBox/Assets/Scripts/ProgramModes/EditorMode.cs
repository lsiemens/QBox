using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EditorMode : MonoBehaviour
{

    private UnityAction OnStateMachineTransitionAction;

    public GameObject editor;

    public List<float[,]> coefficientsList;
    public float[,] coefficientsActive = null;
    public float minimumCoefficiantNorm2 = 1.0e-20f;

    private bool isEditorMode;
    public float gaussianWidth;
    public float gaussianWidthSpeed = 1.0f;
    public float gaussianWidthMinimum = -4.0f;

    void Awake() {
        OnStateMachineTransitionAction = new UnityAction(OnStateMachineTransition);
    }

    void OnEnable() {
        EventManager.RegisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void Start() {
        OnStateMachineTransition();
    }

    void Update() {
        if (isEditorMode) {
            float[,] tmpCoefficients = new float[WaveFunction.NumberOfStates, 2];
            if (coefficientsActive != null) {
                for (int i = 0; i < WaveFunction.NumberOfStates; i++) {
                    tmpCoefficients[i, 0] = coefficientsActive[i, 0];
                    tmpCoefficients[i, 1] = coefficientsActive[i, 1];
                }
            } else {
                foreach (float[,] element in coefficientsList) {
                    for (int i = 0; i < WaveFunction.NumberOfStates; i++) {
                        tmpCoefficients[i, 0] += element[i, 0];
                        tmpCoefficients[i, 1] += element[i, 1];
                    }
                }
            }
            float norm2 = QSystemController.currentQuantumSystem.qMath.InnerProductV(tmpCoefficients);
            if (norm2 > minimumCoefficiantNorm2) {
                QSystemController.currentQuantumSystem.qMath.NormalizeV(tmpCoefficients);
            }
            WaveFunction.SetCoefficients(tmpCoefficients);
            WaveFunction.UpdateRender();
        }
    }

    public void DoneEditing() {
        ProgramStateMachine.AttemptTransition("Run");
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "Edit":
                isEditorMode = true;
                coefficientsList = new List<float[,]>();
                coefficientsActive = null;
                editor.SetActive(true);
                break;
            default:
                isEditorMode = false;
                editor.SetActive(false);
                break;
        }
    }

}
