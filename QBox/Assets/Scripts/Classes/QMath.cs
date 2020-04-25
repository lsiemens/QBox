using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QMath
{
    public int resolution;
    public float length;
    float dx;

    // all functions are assumed to be in the form |F>
    // complex function [index, x, y]
    // coefficients [index, real/imaginary]

    public QMath(int Resolution, float Length) {
        resolution = Resolution;
        length = Length;
        dx = length/(resolution - 1);
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

    // InnerProduct a complex function, <A|B>, [x, y]
    public float[] InnerProductFComplex(float[,] A, float[][,] B, int stride=1) {
        if ((A.GetLength(0) != resolution) || (A.GetLength(1) != resolution)) {
            Debug.LogError("function A must have dimensions resolution X resolution");
        }
        if ((B[0].GetLength(0) != resolution) || (B[0].GetLength(1) != resolution)) {
            Debug.LogError("function B must have dimensions resolution X resolution");
        }
        if (stride < 1) {
            Debug.LogError("stride must be >= 1");
        }
        float[] value = new float[2];
        for (int i = 0; i < resolution/stride; i++) {
            for (int j = 0; j < resolution/stride; j++) {
                value[0] += A[i*stride, j*stride]*B[0][i*stride, j*stride]*dx*dx;
                value[1] += A[i*stride, j*stride]*B[1][i*stride, j*stride]*dx*dx;
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

    public float[][,] GaussianComplex(Vector2 offset, Vector2 velocity, float width) {
        float[][,] gaussian = new float[2][,];
        gaussian[0] = new float[resolution, resolution];
        gaussian[1] = new float[resolution, resolution];
        float cos, sin, exp;
        float x, y;
        float magnitude = 1.0f/(width*Mathf.PI); // compute normalization
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                x = (j - resolution/2)*dx - offset.x;
                y = (i - resolution/2)*dx - offset.y;
                cos = Mathf.Cos(x*velocity.x + y*velocity.y);
                sin = Mathf.Sin(x*velocity.x + y*velocity.y);
                exp = Mathf.Exp(-(x*x + y*y)/(width*width));
                gaussian[0][i, j] = cos*magnitude*exp;
                gaussian[1][i, j] = sin*magnitude*exp;
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

    public float[,] ProjectFunctionComplex(float[][,] states, float[][,] function, int stride=1) {
        if ((function[0].GetLength(0) != resolution) || (function[0].GetLength(1) != resolution)) {
            Debug.LogError("function must have dimensions resolution X resolution");
        }
        float[,] coefficients = new float[states.Length, 2];

        float[] value = new float[2];
        for (int k = 0; k < states.Length; k++) {
            if ((states[k].GetLength(0) != resolution) || (states[k].GetLength(1) != resolution)) {
                Debug.LogError("State[" + k + "] must have dimensions resolution X resolution");
            }
            value = InnerProductFComplex(states[k], function, stride);
            coefficients[k, 0] = value[0];
            coefficients[k, 1] = value[1];
        }
        //NormalizeV(coefficients);
        return coefficients;
    }

    public float MaxFunctionValue(float[,] function) {
        float value = 0;
        for (int i = 0; i < resolution; i++) {
            for (int j = 0; j < resolution; j++) {
                if (Mathf.Abs(function[i, j]) > value) {
                    value = Mathf.Abs(function[i, j]);
                }
            }
        }
        return value;
    }

}
