using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class OptionsMenu : MonoBehaviour
{
    public TMP_Dropdown dropdown;
    public int defaultDropdownOption;
    public int[] NumTexturesOptions;

    void Start() {
        dropdown.ClearOptions();
        List<string> optionsList = new List<string>();
        foreach (int numTextures in NumTexturesOptions) {
            // each texture holds 3 states, display the states in the list
            optionsList.Add((numTextures*3).ToString());
        }
        dropdown.AddOptions(optionsList);
        dropdown.value = defaultDropdownOption;
    }

    public void OnDropdownChangeValue() {
        int dropdownSelection = NumTexturesOptions[dropdown.value];
        Debug.Log("Selection from NumStatesDropdown: " + dropdownSelection);
        MaterialController.instance.shaderMaxReservedIndex = dropdownSelection;
        QSystemController.LoadState();
    }

    public void ResetDialogPreferences() {
        DialogManager.ResetPrefrences();
    }
}
