using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogeManager : MonoBehaviour {
    public Transform dialogeGroup;
    public GameObject dialogePrefab;

    private static DialogeManager dialogeManager;

    public static DialogeManager instance {
        get {
            if (!dialogeManager) {
                dialogeManager = FindObjectOfType(typeof(DialogeManager)) as DialogeManager;
                if (!dialogeManager) {
                    Debug.LogError("No active DialogeManager component found.");
                }
            }
            return dialogeManager;
        }
    }

    public static void show(DialogeContent dialoge) {
        if (!dialoge.dontShowAgain) {
            GameObject newObject = Instantiate(instance.dialogePrefab) as GameObject;
            newObject.transform.SetParent(instance.dialogeGroup, false);
            newObject.SetActive(true);
            // Initalize dynamic button component
            DialogeDriver newComponent = newObject.GetComponent<DialogeDriver>();
            newComponent.Initalize(dialoge);
        }
    }
}
