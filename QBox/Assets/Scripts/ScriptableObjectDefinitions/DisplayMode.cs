using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "QBox/Display Mode")]
public class DisplayMode : ScriptableObject
{
    public Shader shader;
    public string label;
    public int scaleExponent;
}
