using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class InputManager : MonoBehaviour
{
    public RectTransform imageTransform;
    public Canvas canvas;
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

    public static Vector2 GetMousePositionInUI(RectTransform rectTransform) {
        Debug.LogError("need to implement a proper instance variable");
        return inputManager.GetMousePosition(rectTransform);
    }

    public void TriggerRaiseShaderScale() {
        EventManager.TriggerEvent("Raise Shader Scale");
    }

    public void TriggerLowerShaderScale() {
        EventManager.TriggerEvent("Lower Shader Scale");
    }

    public void TriggerRaiseState() {
        EventManager.TriggerEvent("Raise State");
    }

    public void TriggerLowerState() {
        EventManager.TriggerEvent("Lower State");
    }

    public void TriggerCycleShader() {
        EventManager.TriggerEvent("Cycle Shader");
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
            TriggerRaiseState();
        }
        if (Input.GetButtonDown("Lower State")) {
            TriggerLowerState();
        }

        if (Input.GetButtonDown("Cycle Shader")) {
            TriggerCycleShader();
        }

        DetectMouseClick();
    }

    protected abstract void DetectMouseClick();

    protected abstract Vector2 GetMousePosition(RectTransform rectTransform=null);
}
