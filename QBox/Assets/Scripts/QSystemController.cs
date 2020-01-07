using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// QuantumSystemController manages and holds refrences to the QuantumSystems
public class QSystemController : MonoBehaviour
{
    public QuantumSystem quantumSystem;

    // Start is called before the first frame update
    void Start()
    {
        quantumSystem.Load();
    }

    // Update is called once per frame
    void Update()
    {

    }
}
