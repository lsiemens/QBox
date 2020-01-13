using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ManualDataInput : MonoBehaviour
{
    public TMP_InputField real;
    public TMP_InputField imaginary;
    public TextMeshProUGUI label;
    private int coefficientIndex;
    private ScrollListCoefficients scrollListCoefficients;

    public void Initalize(int index, ScrollListCoefficients scrollList) {
        coefficientIndex = index;
        scrollListCoefficients = scrollList;
        label.text = "State: " + index;
    }

    public void OnValueChangedReal() {
        scrollListCoefficients.changeValue(coefficientIndex, true, real.text);
    }

    public void OnValueChangedImaginary() {
        scrollListCoefficients.changeValue(coefficientIndex, false, imaginary.text);
    }
}
