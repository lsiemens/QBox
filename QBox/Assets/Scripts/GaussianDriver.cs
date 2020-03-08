﻿using System.Collections;
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

    public int renderDelayMaximum;

    private float width;
    private float speed;

    private bool getPosition;
    private bool getSpeed;

    private Vector2 gaussianPosition;
    private Vector2 gaussianVelocity;

    private float[][,] gaussian;

    private bool isActive;
    private int renderDelay;

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
        gaussian = QSystemController.currentQuantumSystem.qMath.GaussianComplex(gaussianPosition*QSystemController.currentQuantumSystem.length/2.0f, speed*gaussianVelocity*QSystemController.currentQuantumSystem.length/2.0f, width*QSystemController.currentQuantumSystem.length/2.0f);
        isActive = true;
        renderDelay = renderDelayMaximum;
    }

    public void Close() {
        getPosition = false;
        getSpeed = false;
        renderGaussian();
        editorMode.coefficientsList.Add(editorMode.coefficientsActive);
        isActive = false;
        editorMode.coefficientsActive = null;
    }

    public void OnWidthSliderChange() {
        width = widthSlider.value;
        widthLabel.text = "Width: " + width;
        renderPreview();
    }

    public void OnSpeedSliderChange() {
        speed = speedSlider.value;
        speedLabel.text = "Speed: " + speed;
        renderPreview();
    }

    public void GetMouseInput() {
        getPosition = true;
        getSpeed = false;
        gaussianVelocity = Vector2.zero;
    }

    void renderPreview() {
        renderGaussian(8);
        renderDelay = renderDelayMaximum;
    }

    void renderGaussian(int stride=1) {
        gaussian = QSystemController.currentQuantumSystem.qMath.GaussianComplex(gaussianPosition*QSystemController.currentQuantumSystem.length/2.0f, speed*gaussianVelocity*QSystemController.currentQuantumSystem.length/2.0f, width*QSystemController.currentQuantumSystem.length/2.0f);
        editorMode.coefficientsActive = QSystemController.currentQuantumSystem.ProjectFunctionComplex(gaussian, stride);
        Debug.Log("render gaussian: " + stride);
    }

    void Update() {
        if (isActive) {
            if (getPosition) {
                gaussianPosition = InputManager.mousePosition;
                renderPreview();
                if (Input.GetButtonDown("Mouse Click")) {
                    getPosition = false;
                    getSpeed = true;
                }
            }

            if (getSpeed) {
                gaussianVelocity = (InputManager.mousePosition - gaussianPosition);
                renderPreview();
                if (Input.GetButtonUp("Mouse Click")) {
                    getPosition = false;
                    getSpeed = false;
                }
            }

            if (renderDelay >= 0) {
                renderDelay -= 1;
            }
            if (renderDelay == 0){
                renderGaussian();
            }

        }
    }

}
