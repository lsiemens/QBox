using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class RunSettingMenu : MonoBehaviour
{
    public RunMode runMode;
    public TextMeshProUGUI runSpeedLabel;
    public Slider runSpeed;

    private bool isInitalized=false;

    void OnEnable() {
        runSpeedLabel.text = "Simulation\nspeed: " + runMode.speed;
        runSpeed.value = runMode.speed;
        isInitalized = true;
    }

    public void OnSliderChangeValue() {
        if (isInitalized) {
            runMode.speed = runSpeed.value;
            runSpeedLabel.text = "Simulation\nspeed: " + runMode.speed;
        }
    }

    public void ResetSimulation() {
        runMode.ResetSimulation();
    }
}
