using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class OptionsMenu : MonoBehaviour
{
    public TMP_Dropdown dropdown;
    public int defaultDropdownOption;

    void Start() {
        dropdown.value = defaultDropdownOption;
    }

    public void OnDropdownChangeValue() {
        int value = 0;
        string drodownSelection = dropdown.options[dropdown.value].text;
        if (int.TryParse(drodownSelection, out value)) {
            Debug.Log(drodownSelection);
            MaterialController.instance.shaderMaxReservedIndex = value;
            QSystemController.LoadState();
        } else {
            Debug.Log("Failed to convert selection \"" + drodownSelection + "\" into an integer.");
        }
    }

    public void ResetDialogePreferences() {
        DialogeManager.ResetPrefrences();
    }
}
