using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class PanelControls : MonoBehaviour
{
    public GameObject panel;

    public void TogglePanel() {
        if (panel != null) {
            bool isActive = panel.activeSelf;

            panel.SetActive(!isActive);
        }
    }
}
