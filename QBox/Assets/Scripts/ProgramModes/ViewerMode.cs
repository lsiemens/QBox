using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ViewerMode : MonoBehaviour
{
    private UnityAction OnRaiseStateAction;
    private UnityAction OnLowerStateAction;

    private int viewStateIndex;
    private bool isViewMode;

    private UnityAction OnStateMachineTransitionAction;

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

    void Start() {
        OnStateMachineTransition();
    }

    void ViewUpdate() {
        float[,] coefficients = new float[WaveFunction.NumberOfStates, 2];
        for (int i = 0; i < WaveFunction.NumberOfStates; i++) {
            coefficients[i, 0] = 0.0f;
            coefficients[i, 1] = 0.0f;
            if (i == viewStateIndex) {
                coefficients[i, 0] = 1.0f;
            }
        }
        WaveFunction.SetCoefficients(coefficients);
        WaveFunction.UpdateRender();
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "View":
                viewStateIndex = 0;
                isViewMode = true;
                ViewUpdate();
                DialogManager.Show("stateDialogID");
                break;
            default:
                isViewMode = false;
                break;
        }
    }

    void OnRaiseState() {
        if (isViewMode) {
            if (viewStateIndex + 1 < WaveFunction.NumberOfStates) {
                viewStateIndex++;
            }
            ViewUpdate();
        }
    }

    void OnLowerState(){
        if (isViewMode) {
            if (viewStateIndex > 0) {
                viewStateIndex--;
            }
            ViewUpdate();
        }
    }

}
