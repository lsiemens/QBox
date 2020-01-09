using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
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
    }
}
