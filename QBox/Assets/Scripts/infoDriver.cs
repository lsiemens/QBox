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
            QSystemController.currentQuantumSystem.mass,
            WaveFunction.expectedEnergy,
            runMode.time,
            QSystemController.currentQuantumSystem.potentialMin,
            QSystemController.currentQuantumSystem.potentialMax);
    }

}
