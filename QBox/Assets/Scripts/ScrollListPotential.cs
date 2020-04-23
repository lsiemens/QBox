using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ScrollListPotential : MonoBehaviour
{
    public Transform contentPanel;
    public GameObject prefab;

    void Start() {
        for (int i = 0; i < QSystemController.instance.quantumSystems.Length; i++) {
            // Instantiate new button prefab
            GameObject newObject = Instantiate(prefab) as GameObject;
            newObject.transform.SetParent(contentPanel, false); // worldPositionStays=false to stop incorrect scaleing
            newObject.SetActive(true);
            // Initalize dynamic button component
            PotentialButton newComponent = newObject.GetComponent<PotentialButton>();
            newComponent.Initalize(i);
        }
    }
}
