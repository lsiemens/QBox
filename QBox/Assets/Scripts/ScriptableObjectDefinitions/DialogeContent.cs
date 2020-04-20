using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "QBox/Dialoge Content")]
public class DialogeContent : ScriptableObject
{
    public string id;
    public string title;
    [TextArea]
    public string content;

    // store dontShowAgain as a entry in PlayerPrefs
    public bool dontShowAgain {
        get {
            return PlayerPrefs.HasKey(id);
        }
        set {
            if (value) {
                PlayerPrefs.SetInt(id, 0);
            } else {
                PlayerPrefs.DeleteKey(id);
            }
            PlayerPrefs.Save();
        }
    }
}
