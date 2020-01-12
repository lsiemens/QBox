using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EditorMode : MonoBehaviour
{

    private UnityAction OnStateMachineTransitionAction;

    public GameObject editor;

    private bool isEditorMode;
    private float gaussianWidth;
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
            if (InputManager.mouseScroll != 0.0f) {
                if (gaussianWidth < gaussianWidthMinimum) {
                    gaussianWidth = gaussianWidthMinimum;
                } else {
                    gaussianWidth += gaussianWidthSpeed*Time.deltaTime*InputManager.mouseScroll;
                }
            }

            Debug.Log(gaussianWidth);
            float[,] gaussian = QSystemController.currentQuantumSystem.qMath.Gaussian(InputManager.mousePosition*QSystemController.currentQuantumSystem.xMax, Mathf.Exp(gaussianWidth)*QSystemController.currentQuantumSystem.xMax);

            WaveFunction.SetCoefficients(QSystemController.currentQuantumSystem.ProjectFunction(gaussian));
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
                editor.SetActive(true);
                break;
            default:
                isEditorMode = false;
                editor.SetActive(false);
                break;
        }
    }

}
