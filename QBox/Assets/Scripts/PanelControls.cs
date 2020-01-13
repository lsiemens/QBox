using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using TMPro;

public class PanelControls : MonoBehaviour
{
    public GameObject panel;
    public bool autoClose = true;

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

    public void TogglePanel() {
        if (panel != null) {
            bool isActive = panel.activeSelf;

            panel.SetActive(!isActive);
        }
    }

    void OnStateMachineTransition() {
        if (autoClose) {
            panel.SetActive(false);
        }
    }

}
