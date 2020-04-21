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

    protected override Vector2 GetMousePosition(RectTransform rectTransform) {
        Debug.Log((Input.mousePosition - imageTransform.position));
        Vector2 pos;

        if (rectTransform is null) {
            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                canvas.transform as RectTransform, Input.mousePosition,
                canvas.worldCamera,
                out pos);
            Debug.Log(pos + " " + imageTransform.rect.width);

            return 2*(pos)/imageTransform.rect.width;
        } else {
            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                rectTransform, Input.mousePosition,
                canvas.worldCamera,
                out pos);
            Debug.Log(pos + " " + rectTransform.rect.width);

            return 2*(pos)/rectTransform.rect.width;
        }
    }
}
