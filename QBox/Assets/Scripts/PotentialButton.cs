using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PotentialButton : MonoBehaviour
{
    public Button button;
    public TextMeshProUGUI potentialLabel;
    public RawImage potentialPreview;
    private int quantumSystemIndex;

    public void Initalize(int index) {
        quantumSystemIndex = index;
        QuantumSystem quantumSystem = QSystemController.instance.quantumSystems[quantumSystemIndex];
        button.onClick.AddListener(OnClick);
        potentialPreview.texture = quantumSystem.potentialTextureEXR;
        potentialLabel.text = quantumSystem.potentialLabel;
    }

    void OnClick() {
        QSystemController.LoadState(quantumSystemIndex);
    }
}
