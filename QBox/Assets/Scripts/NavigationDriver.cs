using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

public class NavigationDriver : MonoBehaviour
{
    public Button viewButton;
    public Button editButton;
    public Color modeColor;

    private UnityAction OnStateMachineTransitionAction;

    void Awake() {
        OnStateMachineTransitionAction = new UnityAction(OnStateMachineTransition);
    }

    void OnEnable() {
        EventManager.RegisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "View":
                viewButton.image.color = modeColor;
                editButton.image.color = Color.white;
                break;
            case "Edit":
                viewButton.image.color = Color.white;
                editButton.image.color = modeColor;
                break;
        }
    }
}
