using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    public RectTransform imageTransform;
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

        if (Input.GetButtonDown("Raise State")) {
            EventManager.TriggerEvent("Raise State");
        }
        if (Input.GetButtonDown("Lower State")) {
            EventManager.TriggerEvent("Lower State");
        }

        if (Input.GetButtonDown("Cycle Shader")) {
            EventManager.TriggerEvent("Cycle Shader");
        }
    }

    Vector2 GetMousePosition() {
        return 2*(Input.mousePosition - imageTransform.position)/imageTransform.rect.width;
    }
}
