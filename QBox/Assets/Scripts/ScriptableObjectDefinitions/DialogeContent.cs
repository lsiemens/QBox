using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "QBox/Dialoge Content")]
public class DialogeContent : ScriptableObject
{
    public string title;
    [TextArea]
    public string content;
    public bool dontShowAgain;
}
