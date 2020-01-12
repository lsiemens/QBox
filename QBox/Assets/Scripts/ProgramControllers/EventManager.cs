using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EventManager : MonoBehaviour {
    private Dictionary<string, UnityEvent> eventDictionary;
    private bool eventLock;

    private static EventManager eventManager;

    public static EventManager instance {
        get {
            if (!eventManager) {
                eventManager = FindObjectOfType(typeof(EventManager)) as EventManager;
                if (!eventManager) {
                    Debug.LogError("No active EventManager component found.");
                } else {
                    eventManager.Initalize();
                }
            }
            return eventManager;
        }
    }

    public static void RegisterListener(string eventName, UnityAction listener) {
        UnityEvent newEvent = null;
        if (instance.eventDictionary.TryGetValue(eventName, out newEvent)) {
            newEvent.AddListener(listener);
        } else {
            newEvent = new UnityEvent();
            newEvent.AddListener(listener);
            instance.eventDictionary.Add(eventName, newEvent);
        }
    }

    void Initalize() {
        eventLock=false;
        if (eventDictionary == null) {
            eventDictionary = new Dictionary<string, UnityEvent>();
        }
    }

    public static void DeregisterListener(string eventName, UnityAction listener) {
        if (eventManager == null) return;
        UnityEvent thisEvent = null;
        if (instance.eventDictionary.TryGetValue(eventName, out thisEvent)) {
            thisEvent.RemoveListener(listener);
        }
    }

    public static void TriggerEvent(string eventName) {
        UnityEvent thisEvent = null;
        if (instance.eventDictionary.TryGetValue(eventName, out thisEvent)) {
            if (!instance.eventLock) {
                instance.eventLock = true;
                thisEvent.Invoke();
                instance.eventLock = false;
            } else {
                Debug.LogError("Events can not be triggered while processing events.");
            }
        }
    }
}
