using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
using TMPro;

public class DialogeDriver : MonoBehaviour
{
    public TextMeshProUGUI title;
    public TextMeshProUGUI content;
    public Toggle dontShowAgain;

    private DialogeContent dialogeContent;
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

    public void Initalize(DialogeContent dialoge) {
        dialogeContent = dialoge;
        title.text = dialogeContent.title;
        content.text = dialogeContent.content;
        dontShowAgain.isOn = dialogeContent.dontShowAgain;
    }

    public void ToggleValueChanged() {
        dialogeContent.dontShowAgain = dontShowAgain.isOn;
    }

    public void closePanel() {
        Destroy(this.gameObject);
    }

    void OnStateMachineTransition() {
        closePanel();
    }
}
