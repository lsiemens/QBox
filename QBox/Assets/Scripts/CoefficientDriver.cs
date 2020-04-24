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

    private float active;
    private float probability;
    private int index = 0;

    void OnEnable() {
        NumberOfStates = WaveFunction.NumberOfStates;
        index = 0;
        editorMode.coefficientsActive = new float[NumberOfStates, 2];
        material = GetComponent<Image>().material;
        active = 1.0f;
        probability = 0.0f;
        remainingStatesLabel.text = "States Left: " + (NumberOfStates - 1);
        material.SetFloat("radius", active);

        DialogManager.Show("wheelDialogID");
    }

    public void Done() {
        editorMode.coefficientsList.Add(editorMode.coefficientsActive);
        editorMode.coefficientsActive = null;
    }

    public void OnClick() {
        if (index < NumberOfStates) {

            Vector2 mousePosition = InputManager.GetMousePositionInUI(imageRect);

            if (mousePosition.magnitude < active) {
                Vector2 coefficient = mousePosition;
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
