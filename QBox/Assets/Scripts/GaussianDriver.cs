using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class GaussianDriver : MonoBehaviour
{
    public EditorMode editorMode;
    public TextMeshProUGUI widthLabel;
    public TextMeshProUGUI speedLabel;
    public Slider widthSlider;
    public Slider speedSlider;

    public float minWidthSlider;
    public float maxWidthSlider;
    public float defaultWidth;
    public float maxSpeedSlider;
    public float defaultSpeed;

    private float width;
    private float speed;

    private bool getPosition;
    private bool getSpeed;

    private Vector2 gaussianPosition;
    private Vector2 gaussianVelocity;

    private bool isActive;

    void OnEnable() {
        isActive = false;
    }

    public void Initalize() {
        gaussianPosition = Vector2.zero;
        gaussianVelocity = Vector2.zero;
        getPosition = false;
        getSpeed = false;
        width = defaultWidth;
        speed = defaultSpeed;
        widthLabel.text = "Width: " + width;
        speedLabel.text = "Speed: " + speed;
        widthSlider.maxValue = maxWidthSlider;
        widthSlider.minValue = minWidthSlider;
        widthSlider.value = width;
        speedSlider.maxValue = maxSpeedSlider;
        speedSlider.minValue = 0.0f;
        speedSlider.value = speed;
        editorMode.coefficientsActive = new float[WaveFunction.NumberOfStates, 2];
        isActive = true;
    }

    public void Close() {
        getPosition = false;
        getSpeed = false;
        editorMode.coefficientsList.Add(editorMode.coefficientsActive);
        isActive = false;
        editorMode.coefficientsActive = null;
    }

    public void OnWidthSliderChange() {
        width = widthSlider.value;
        widthLabel.text = "Width: " + width;
    }

    public void OnSpeedSliderChange() {
        speed = speedSlider.value;
        speedLabel.text = "Speed: " + speed;
    }

    public void GetMouseInput() {
        getPosition = true;
        getSpeed = false;
        gaussianVelocity = Vector2.zero;
    }

    void Update() {
        if (isActive) {
            if (getPosition) {
                gaussianPosition = InputManager.mousePosition;
                if (Input.GetButtonDown("Mouse Click")) {
                    getPosition = false;
                    getSpeed = true;
                }
            }

            if (getSpeed) {
                gaussianVelocity = (InputManager.mousePosition - gaussianPosition);
                if (Input.GetButtonUp("Mouse Click")) {
                    getPosition = false;
                    getSpeed = false;
                }
            }

            float[][,] gaussian = QSystemController.currentQuantumSystem.qMath.GaussianComplex(gaussianPosition*QSystemController.currentQuantumSystem.xMax, speed*gaussianVelocity*QSystemController.currentQuantumSystem.xMax, width*QSystemController.currentQuantumSystem.xMax);
            editorMode.coefficientsActive = QSystemController.currentQuantumSystem.ProjectFunctionComplex(gaussian);


//            float[,] gaussian = QSystemController.currentQuantumSystem.qMath.Gaussian(gaussianPosition*QSystemController.currentQuantumSystem.xMax, width*QSystemController.currentQuantumSystem.xMax);
//            editorMode.coefficientsActive = QSystemController.currentQuantumSystem.ProjectFunction(gaussian);
        }
    }

}
