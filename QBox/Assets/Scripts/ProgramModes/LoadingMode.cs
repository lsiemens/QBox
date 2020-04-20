using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LoadingMode : MonoBehaviour
{
    private UnityAction OnStateMachineTransitionAction;

    public GameObject loading;

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

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "Loading":
                loading.SetActive(true);
                // Start load sequence next frame to give objects time to process Loading transition.
                StartCoroutine(LoadingCoroutine());
                break;
            default:
                if (loading.activeSelf) {
                    DialogeManager.Show("displayDialogeID");
                }
                loading.SetActive(false);
                break;
        }
    }

    IEnumerator LoadingCoroutine() {
        yield return null;
        WaveFunction.Reload();
        ProgramStateMachine.AttemptTransition("View");
    }

}
