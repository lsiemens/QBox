using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    private static InputManager inputManager;

    public static Vector2 mousePosition {
        get {
            if (!inputManager) {
                inputManager = FindObjectOfType(typeof(InputManager)) as InputManager;
                if (!inputManager) {
                    Debug.LogError("No active InputManager component found.");
                }
            }
            return inputManager.GetMousePosition();
        }
    }

    public static float mouseScroll {
        get {
            return Input.mouseScrollDelta.y;
        }
    }

    public static float shaderScale {
        get {
            return Input.GetAxis("Shader Scale");
        }
    }

    void Update()
    {
        if (Input.GetButtonDown("Edit Mode")) {
            ProgramStateMachine.AttemptTransition("Edit");
        }
        if (Input.GetButtonDown("View Mode")) {
            ProgramStateMachine.AttemptTransition("View");
        }
        if (Input.GetButtonDown("Mouse Click")) {
            ProgramStateMachine.AttemptTransition("Run");
        }

        if (Input.GetButtonDown("Raise State")) {
            EventManager.TriggerEvent("Raise State");
            Debug.Log("Raise state");
        }
        if (Input.GetButtonDown("Lower State")) {
            EventManager.TriggerEvent("Lower State");
        }

        if (Input.GetButtonDown("Cycle Shader")) {
            EventManager.TriggerEvent("Cycle Shader");
        }
    }

    Vector2 GetMousePosition() {
        return new Vector2(2*Input.mousePosition.x/Screen.width - 1.0f, 2*Input.mousePosition.y/Screen.height - 1.0f);
    }
}
