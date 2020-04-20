using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogeManager : MonoBehaviour {
    public Transform dialogeGroup;
    public GameObject dialogePrefab;

    public DialogeContent[] dialogeList;

    private Dictionary<string, DialogeContent> dialogeDictionary;
    private static DialogeManager dialogeManager;

    public static DialogeManager instance {
        get {
            if (!dialogeManager) {
                dialogeManager = FindObjectOfType(typeof(DialogeManager)) as DialogeManager;
                if (!dialogeManager) {
                    Debug.LogError("No active DialogeManager component found.");
                } else {
                    dialogeManager.Initalize();
                }
            }
            return dialogeManager;
        }
    }

    void Initalize() {
        if (dialogeDictionary == null) {
            dialogeDictionary = new Dictionary<string, DialogeContent>();
            foreach (DialogeContent dialoge in dialogeList) {
                dialogeDictionary.Add(dialoge.id, dialoge);
            }
        }
    }

    public static void Show(string dialogeId) {
        DialogeContent dialoge = null;
        if (instance.dialogeDictionary.TryGetValue(dialogeId, out dialoge)) {
            if (!dialoge.dontShowAgain) {
                GameObject newObject = Instantiate(instance.dialogePrefab) as GameObject;
                newObject.transform.SetParent(instance.dialogeGroup, false);
                newObject.SetActive(true);
                // Initalize dynamic button component
                DialogeDriver newComponent = newObject.GetComponent<DialogeDriver>();
                newComponent.Initalize(dialoge);
            }
        } else {
            Debug.LogError("No dialoge found with id:" + dialogeId);
        }
    }

    public static void ResetPrefrences() {
        foreach (DialogeContent dialoge in instance.dialogeList) {
            dialoge.dontShowAgain = false;
        }
    }
}
