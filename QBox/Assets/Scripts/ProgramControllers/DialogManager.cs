using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogManager : MonoBehaviour {
    public Transform dialogGroup;
    public GameObject dialogPrefab;

    public DialogContent[] dialogList;

    private Dictionary<string, DialogContent> dialogDictionary;
    private static DialogManager dialogManager;

    public static DialogManager instance {
        get {
            if (!dialogManager) {
                dialogManager = FindObjectOfType(typeof(DialogManager)) as DialogManager;
                if (!dialogManager) {
                    Debug.LogError("No active DialogManager component found.");
                } else {
                    dialogManager.Initalize();
                }
            }
            return dialogManager;
        }
    }

    void Initalize() {
        if (dialogDictionary == null) {
            dialogDictionary = new Dictionary<string, DialogContent>();
            foreach (DialogContent dialog in dialogList) {
                dialogDictionary.Add(dialog.id, dialog);
            }
        }
    }

    public static void Show(string dialogId) {
        DialogContent dialog = null;
        if (instance.dialogDictionary.TryGetValue(dialogId, out dialog)) {
            if (!dialog.dontShowAgain) {
                GameObject newObject = Instantiate(instance.dialogPrefab) as GameObject;
                newObject.transform.SetParent(instance.dialogGroup, false);
                newObject.SetActive(true);
                // Initalize dynamic button component
                DialogDriver newComponent = newObject.GetComponent<DialogDriver>();
                newComponent.Initalize(dialog);
            }
        } else {
            Debug.LogError("No dialog found with id:" + dialogId);
        }
    }

    public static void ResetPrefrences() {
        foreach (DialogContent dialog in instance.dialogList) {
            dialog.dontShowAgain = false;
        }
    }
}
