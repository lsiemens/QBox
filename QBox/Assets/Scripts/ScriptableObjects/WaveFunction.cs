using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// WaveFunction contains all the the nessisary information to describe a quantum
// superposition and methods to get its time evelution.
[CreateAssetMenu(menuName = "QBox/Quantum Objects/WaveFunction")]
public class WaveFunction : ScriptableObject
{
    public QuantumSystem quantumSystem;
}
