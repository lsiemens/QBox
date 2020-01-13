using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class RunMode : MonoBehaviour
{

    public float speed;
    private float time;
    private UnityAction OnStateMachineTransitionAction;
    private bool isRunMode;

    public GameObject run;

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
        if (isRunMode) {
            time += speed*Time.deltaTime;
            WaveFunction.UpdateRender(time);
        }
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        time = 0.0f;
        switch (state) {
            case "Run":
                isRunMode = true;
                run.SetActive(true);
                break;
            default:
                isRunMode = false;
                run.SetActive(false);
                break;
        }
    }

}
