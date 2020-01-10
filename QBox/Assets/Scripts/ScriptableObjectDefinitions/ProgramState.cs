using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "QBox/Program State")]
public class ProgramState : ScriptableObject
{
    public string state;
    public Dictionary<string, ProgramState> stateTransitions;
    public ProgramState[] populateStates;

    void OnEnable() {
        stateTransitions = new Dictionary<string, ProgramState>();
        foreach (ProgramState tempState in populateStates) {
            stateTransitions.Add(tempState.state, tempState);
        }
    }
}
