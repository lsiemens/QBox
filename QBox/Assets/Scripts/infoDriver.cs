using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class infoDriver : MonoBehaviour
{
    public TextMeshProUGUI content;
    public RunMode runMode;
    [TextArea]
    public string text;

    void Update() {
        content.text = string.Format(text,
            QSystemController.currentQuantumSystem.potentialLabel,
            MaterialController.ShaderLabel(),
            QSystemController.currentQuantumSystem.length,
            1.0,
            WaveFunction.expectedEnergy,
            runMode.time);
    }

}
