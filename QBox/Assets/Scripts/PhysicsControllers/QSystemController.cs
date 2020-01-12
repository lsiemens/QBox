using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystemController manages and holds refrences to the QuantumSystems
public class QSystemController : MonoBehaviour
{
    public QuantumSystem quantumSystem;

    private static QSystemController qsystemController;
    private bool isLoaded=false;
    [Tooltip("Minimum number of frames to display the loading screen.")]
    public int delayedLoading;

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

    void Update() {
        Debug.Log("u");
        if ((!isLoaded) && (Time.frameCount > delayedLoading)) {
            Debug.Log(Time.time);
            quantumSystem.Load();
            ProgramStateMachine.AttemptTransition("View");
            isLoaded = true;
        }
    }

}
