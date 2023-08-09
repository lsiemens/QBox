using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManagerTouch : InputManager
{
    private Vector3 lastTouchLocation;

    void OnEnable() {
        Lean.Touch.LeanTouch.OnFingerUp += HandleFingerUp;
        Lean.Touch.LeanTouch.OnFingerUpdate += HandleFingerUpdate;
        Lean.Touch.LeanTouch.OnFingerDown += HandleFingerDown;
        lastTouchLocation = Vector3.zero;
    }

    void OnDisable() {
        Lean.Touch.LeanTouch.OnFingerUp -= HandleFingerUp;
        Lean.Touch.LeanTouch.OnFingerUpdate -= HandleFingerUpdate;
        Lean.Touch.LeanTouch.OnFingerDown -= HandleFingerDown;
    }

    void HandleFingerUp(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
        EventManager.TriggerEvent("Mouse Click Up");
    }

    void HandleFingerUpdate(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
    }

    void HandleFingerDown(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
        EventManager.TriggerEvent("Mouse Click Down");
    }

    protected override void DetectMouseClick() {
    }

    protected override Vector2 GetMousePosition(RectTransform rectTransform) {
        Debug.Log((lastTouchLocation - imageTransform.position));
        Vector2 pos;

        if (rectTransform is null) {
            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                canvas.transform as RectTransform, lastTouchLocation,
                canvas.worldCamera,
                out pos);
            Debug.Log(pos + " " + imageTransform.rect.width);

            return 2*(pos)/imageTransform.rect.width;
        } else {
            RectTransformUtility.ScreenPointToLocalPointInRectangle(
                rectTransform, lastTouchLocation,
                canvas.worldCamera,
                out pos);
            Debug.Log(pos + " " + rectTransform.rect.width);

            return 2*(pos)/rectTransform.rect.width;
        }
    }
}
