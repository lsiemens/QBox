using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManagerMouse : InputManager
{
    protected override void DetectMouseClick() {
        if (Input.GetButtonUp("Mouse Click")) {
            EventManager.TriggerEvent("Mouse Click Up");
        }

        if (Input.GetButtonDown("Mouse Click")) {
            EventManager.TriggerEvent("Mouse Click Down");
        }
    }

   protected override Vector2 GetMousePosition() {
        return 2*(Input.mousePosition - imageTransform.position)/imageTransform.rect.width;
    }
}
