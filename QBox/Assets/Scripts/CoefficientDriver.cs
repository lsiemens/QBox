using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class CoefficientDriver : MonoBehaviour
{
    public float[,] coefficients;
    [System.NonSerialized] public int NumberOfStates;
    public EditorMode editorMode;
    public TextMeshProUGUI remainingStatesLabel;
    public RectTransform imageRect;

    private Material material;
    private float halfSize;

    private float active;
    private float probability;
    private int index = 0;

    void OnEnable() {
        NumberOfStates = WaveFunction.NumberOfStates;
        index = 0;
        editorMode.coefficientsActive = new float[NumberOfStates, 2];
        halfSize = imageRect.rect.width/2;
        material = GetComponent<Image>().material;
        active = 1.0f;
        probability = 0.0f;
        remainingStatesLabel.text = "States Left: " + (NumberOfStates - 1);
        material.SetFloat("radius", active);

        DialogeManager.Show("wheelDialogeID");
    }

    public void Done() {
        editorMode.coefficientsList.Add(editorMode.coefficientsActive);
        editorMode.coefficientsActive = null;
    }

    public void OnClick() {
        halfSize = imageRect.rect.width/2; // reset halfSize to account for any dynamic changes in the widget

        if (index < NumberOfStates) {
            if (Vector2.Distance(imageRect.position, Input.mousePosition)/halfSize < active) {
                Vector2 coefficient = (imageRect.position - Input.mousePosition)/halfSize;
                if  (index == NumberOfStates - 1) {
                    coefficient = active*coefficient.normalized;
                }
                editorMode.coefficientsActive[index, 0] = coefficient.x;
                editorMode.coefficientsActive[index, 1] = coefficient.y;
                probability += coefficient.sqrMagnitude;
                active = Mathf.Sqrt(1 - probability);
                material.SetFloat("radius", active);
                remainingStatesLabel.text = "States Left: " + (NumberOfStates - index - 1);
                index++;
            }
        }
    }
}
