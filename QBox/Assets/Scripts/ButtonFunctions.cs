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

    public void OpenDocumentation() {
        # if UNITY_ANDROID
            Application.OpenURL("https://qbox.lsiemens.com/Documentation/AndroidUserGuide.html");
        # else
            Application.OpenURL("https://qbox.lsiemens.com/Documentation/README.html");
        # endif
    }

    public void NavigationView() {
        ProgramStateMachine.AttemptTransition("View");
    }

    public void NavigationEdit() {
        ProgramStateMachine.AttemptTransition("Edit");
    }
}
