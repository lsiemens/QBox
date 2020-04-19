using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonFunctions : MonoBehaviour
{
    public void ApplicationExit() {
        #if UNITY_STANDALONE
            Application.Quit();
        #endif

        #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }

    public void NavigationView() {
        ProgramStateMachine.AttemptTransition("View");
    }

    public void NavigationEdit() {
        ProgramStateMachine.AttemptTransition("Edit");
    }
}
