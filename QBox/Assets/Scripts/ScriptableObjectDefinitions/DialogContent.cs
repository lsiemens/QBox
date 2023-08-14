using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "QBox/Dialog Content")]
public class DialogContent : ScriptableObject
{
    public string id;
    public string title;
    public TextAsset content;

    // store dontShowAgain as a entry in PlayerPrefs
    public bool dontShowAgain {
        get {
            return PlayerPrefs.HasKey(id);
        }
        set {
            Debug.Log("set key:" + id + " to " + value);
            if (value) {
                PlayerPrefs.SetInt(id, 0);
            } else {
                PlayerPrefs.DeleteKey(id);
            }
            PlayerPrefs.Save();
        }
    }
}
