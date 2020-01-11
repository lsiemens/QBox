﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QMath
{
    public int resolution;
    public float xMax;
    float dx;

    // all functions are assumed to be in the form |F>
    // complex function [index, x, y]
    // coefficients [index, real/imaginary]

    public QMath(int Resolution, float XMax) {
        resolution = Resolution;
        xMax = XMax;
        dx = 2*xMax/(resolution - 1);
    }

    // InnerProduct a real function, <A|B>, [x, y]
    public float InnerProductF(float[,] A, float[,] B) {
        if ((A.GetLength(0) != resolution) || (A.GetLength(1) != resolution)) {
            Debug.LogError("function A must have dimensions resolution X resolution");
        }
        if ((B.GetLength(0) != resolution) || (B.GetLength(1) != resolution)) {
            Debug.LogError("function B must have dimensions resolution X resolution");
        }
        float value = 0.0f;
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                value += A[i, j]*B[i, j]*dx*dx;
            }
        }
        return value;
    }

    // InnerProduct of a complex vector, [index, real/imaginary]
    public float InnerProductV(float[,] data) {
        if (data.GetLength(1) != 2) {
            Debug.LogError("Vector data must be array of complex numbers. shape [n,2]");
        }
        float value = 0.0f;
        for (int i = 0; i < data.GetLength(0); i++) {
            value += data[i, 0]*data[i, 0] + data[i, 1]*data[i, 1];
        }
        return value;
    }

    public void NormalizeV(float[,] data) {
        if (data.GetLength(1) != 2) {
            Debug.LogError("Vector data must be array of complex numbers. shape [n,2]");
        }
        float magnitude = Mathf.Sqrt(InnerProductV(data));
        for (int i = 0; i < data.GetLength(0); i++) {
            data[i, 0] /= magnitude;
            data[i, 1] /= magnitude;
        }
    }

    public void NormalizeF(float[,] data) {
        if ((data.GetLength(0) != resolution) || (data.GetLength(1) != resolution)) {
            Debug.LogError("function data must have dimensions resolution X resolution");
        }
        float magnitude = Mathf.Sqrt(InnerProductF(data, data));
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                data[i, j] /= magnitude;
            }
        }
    }

    public float[,] Gaussian(Vector2 offset, float width) {
        float[,] gaussian = new float[resolution, resolution];
        float x, y;
        float magnitude = 1.0f; // compute normalization
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                x = (j - resolution/2)*dx - offset.x;
                y = (i - resolution/2)*dx - offset.y;
                gaussian[i, j] = magnitude*Mathf.Exp(-(x*x + y*y)/(width*width));
            }
        }
        return gaussian;
    }

    public float[,] ProjectFunction(float[][,] states, float[,] function) {
        if ((function.GetLength(0) != resolution) || (function.GetLength(1) != resolution)) {
            Debug.LogError("function must have dimensions resolution X resolution");
        }
        float[,] coefficients = new float[states.Length, 2];

        for (int k = 0; k < states.Length; k++) {
            if ((states[k].GetLength(0) != resolution) || (states[k].GetLength(1) != resolution)) {
                Debug.LogError("State[" + k + "] must have dimensions resolution X resolution");
            }
            coefficients[k, 0] = InnerProductF(states[k], function);
        }
        NormalizeV(coefficients);
        return coefficients;
    }

}