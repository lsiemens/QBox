using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EditorController : MonoBehaviour
{

    private UnityAction OnStateMachineTransitionAction;

    public GameObject editor;

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
        OnStateMachineTransition();
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "Edit":
                editor.SetActive(true);
                break;
            default:
                editor.SetActive(false);
                break;
        }
    }

}
