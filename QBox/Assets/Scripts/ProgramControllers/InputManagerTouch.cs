using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManagerTouch : InputManager
{
    private Vector2 lastTouchLocation;

    void OnEnable() {
        Lean.Touch.LeanTouch.OnFingerUp += HandleFingerUp;
        Lean.Touch.LeanTouch.OnFingerSet += HandleFingerSet;
        Lean.Touch.LeanTouch.OnFingerDown += HandleFingerDown;
        lastTouchLocation = Vector2.zero;
    }

    void OnDisable() {
        Lean.Touch.LeanTouch.OnFingerUp -= HandleFingerUp;
        Lean.Touch.LeanTouch.OnFingerSet -= HandleFingerSet;
        Lean.Touch.LeanTouch.OnFingerDown -= HandleFingerDown;
    }

    void HandleFingerUp(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
        EventManager.TriggerEvent("Mouse Click Up");
    }

    void HandleFingerSet(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
    }

    void HandleFingerDown(Lean.Touch.LeanFinger finger) {
        lastTouchLocation = finger.ScreenPosition;
        EventManager.TriggerEvent("Mouse Click Down");
    }

    protected override void DetectMouseClick() {
    }

    protected override Vector2 GetMousePosition(RectTransform rectTransform) {
        Debug.LogError("Need to implement rect transform");
        return 2*(new Vector3(lastTouchLocation.x, lastTouchLocation.y, 0) - imageTransform.position)/imageTransform.rect.width;
    }
}
