using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystemController manages and holds refrences to the QuantumSystems
public class QSystemController : MonoBehaviour
{
    [System.NonSerialized] int quantumSystemIndex=0;
    public QuantumSystem[] quantumSystems;

    private static QSystemController qsystemController;

    public static QuantumSystem currentQuantumSystem {
        get {
            return instance.quantumSystems[qsystemController.quantumSystemIndex];
        }
    }

    public static QSystemController instance {
        get {
            if (!qsystemController) {
                qsystemController = (QSystemController)FindObjectOfType(typeof(QSystemController));
                if (!qsystemController) {
                    Debug.LogError("No active QSystemController component found.");
                }
            }
            return qsystemController;
        }
    }

    public static void LoadState(int index) {
        if ((index < 0) || (index >= instance.quantumSystems.Length)) {
            Debug.LogError("Can not load state " + index + " index is out of bounds.");
        }
        instance.quantumSystemIndex = index;
        ProgramStateMachine.AttemptTransition("Loading");
    }

    public static void Reload() {
        MaterialController.Reload();
        instance.quantumSystems[instance.quantumSystemIndex].Load();
    }

}
