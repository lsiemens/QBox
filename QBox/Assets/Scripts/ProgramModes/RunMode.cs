﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class RunMode : MonoBehaviour
{

    public float speed;
    [System.NonSerialized] public float time;
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

    public void ResetSimulation() {
        if (isRunMode) {
            time = 0;
            WaveFunction.UpdateRender(time);
        }
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
                Screen.sleepTimeout = SleepTimeout.NeverSleep;
                break;
            default:
                isRunMode = false;
                run.SetActive(false);
                Screen.sleepTimeout = SleepTimeout.SystemSetting;
                break;
        }
    }

}
