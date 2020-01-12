using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystemController manages and holds refrences to the QuantumSystems
public class QSystemController : MonoBehaviour
{
    [System.NonSerialized] int quantumSystemIndex=0;
    public QuantumSystem[] quantumSystems;

    private static QSystemController qsystemController;
    private bool isLoaded=false;
    [Tooltip("Minimum number of frames to display the loading screen.")]
    public int delayedLoading;
    int frameCount = 0;

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
                } else {
                    qsystemController.Initalize();
                }
            }
            return qsystemController;
        }
    }

    void Initalize() {
        frameCount = 0;
        isLoaded = false;
    }

    void Update() {
        if ((!isLoaded) && (frameCount > delayedLoading)) {
            quantumSystems[quantumSystemIndex].Load();
            ProgramStateMachine.AttemptTransition("View");
            isLoaded = true;
        }
        frameCount++;
    }

    public static void LoadState(int index) {
        if ((index < 0) || (index >= instance.quantumSystems.Length)) {
            Debug.LogError("Can not load state " + index + " index is out of bounds.");
        }
        instance.quantumSystemIndex = index;
        instance.Initalize();
        ProgramStateMachine.AttemptTransition("Loading");
    }

}
