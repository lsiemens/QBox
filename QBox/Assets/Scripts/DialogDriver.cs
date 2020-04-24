using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
using TMPro;

public class DialogDriver : MonoBehaviour
{
    public TextMeshProUGUI title;
    public TextMeshProUGUI content;
    public Toggle dontShowAgain;

    private DialogContent dialogContent;
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

    public void Initalize(DialogContent dialog) {
        dialogContent = dialog;
        title.text = dialogContent.title;
        content.text = dialogContent.content;
        dontShowAgain.isOn = dialogContent.dontShowAgain;
    }

    public void ToggleValueChanged() {
        dialogContent.dontShowAgain = dontShowAgain.isOn;
    }

    public void closePanel() {
        Destroy(this.gameObject);
    }

    void OnStateMachineTransition() {
        closePanel();
    }
}
