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

    void OnEnable() {
        runSpeedLabel.text = "Simulation\nspeed: " + runMode.speed;
        runSpeed.value = runMode.speed;
    }

    public void OnSliderChangeValue() {
        runMode.speed = runSpeed.value;
        runSpeedLabel.text = "Simulation\nspeed: " + runMode.speed;
    }

    public void ResetSimulation() {
        runMode.ResetSimulation();
    }
}
