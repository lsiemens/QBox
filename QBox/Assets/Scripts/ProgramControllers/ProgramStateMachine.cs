using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Settup and manage the general game mode
public class ProgramStateMachine : MonoBehaviour
{
    public ProgramState initalState;

    private ProgramState currentState;
    private static ProgramStateMachine programStateMachine;

    public static string state {
        get {
            return instance.currentState.state;
        }
    }

    private static ProgramStateMachine instance {
        get {
            if (!programStateMachine) {
                programStateMachine = FindObjectOfType(typeof(ProgramStateMachine)) as ProgramStateMachine;
                if (!programStateMachine) {
                    Debug.LogError("No active ProgramStateMachine component found.");
                } else {
                    programStateMachine.Initalize();
                }
            }
            return programStateMachine;
        }
    }

    public static void AttemptTransition(string state) {
        ProgramState newState = null;
        if (instance.currentState.stateTransitions.TryGetValue(state, out newState)) {
            instance.currentState = newState;
            EventManager.TriggerEvent("OnStateMachineTransition");
        } else {
            Debug.Log("Failed attempt to change state to " + state + " the current state is " + instance.currentState.state);
        }
    }


    void Initalize() {
        currentState = initalState;
    }
}
