using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ScrollListCoefficients : MonoBehaviour
{
    public Transform contentPanel;
    public GameObject prefab;
    public EditorMode editorMode;
    private Stack<GameObject> objects = new Stack<GameObject>();

    void Start() {
    }

    public void AddElements() {
        editorMode.coefficientsActive = new float[WaveFunction.NumberOfStates,2];
        for (int i = 0; i < WaveFunction.NumberOfStates; i++) {
            // Instantiate new button prefab
            GameObject newObject = Instantiate(prefab) as GameObject;
            objects.Push(newObject);
            newObject.transform.SetParent(contentPanel);
            newObject.SetActive(true);
            // Initalize dynamic button component
            ManualDataInput newComponent = newObject.GetComponent<ManualDataInput>();
            newComponent.Initalize(i, this);
        }
    }

    public void changeValue(int index, bool isReal, string value) {
        if (isReal) {
            editorMode.coefficientsActive[index, 0] = System.Convert.ToSingle(value);
        } else {
            editorMode.coefficientsActive[index, 1] = System.Convert.ToSingle(value);
        }
    }

    public void RemoveElements() {
        while (objects.Count > 0) {
            Destroy(objects.Pop());
        }

        editorMode.coefficientsList.Add(editorMode.coefficientsActive);
        editorMode.coefficientsActive = null;
    }

/*    void Start() {
        for (int i = 0; i < WaveFunction.NumberOfStates; i++) {
            // Instantiate new button prefab
            GameObject newObject = Instantiate(prefab) as GameObject;
            newObject.transform.SetParent(contentPanel);
            newObject.SetActive(true);
            // Initalize dynamic button component
            ManualDataInput newComponent = newObject.GetComponent<ManualDataInput>();
            newComponent.Initalize(i);
        }
    }*/
}
