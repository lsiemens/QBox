using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystemController manages and holds refrences to the QuantumSystems
public class QSystemController : MonoBehaviour
{
    public QuantumSystem quantumSystem;

    private static QSystemController qsystemController;

    public static QuantumSystem currentQuantumSystem {
        get {
            if (!qsystemController) {
                qsystemController = (QSystemController)FindObjectOfType(typeof(QSystemController));
                if (!qsystemController) {
                    Debug.LogError("No active QSystemController component found.");
                }
            }
            return qsystemController.quantumSystem;
        }
    }

    void Start()
    {
        quantumSystem.Load();
    }
}
