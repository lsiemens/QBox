using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MaterialController : MonoBehaviour
{
    public Material material;
    public Shader[] shaders;
    [Tooltip("Maximum array size to reserve in the shader.")]
    public int shaderMaxReservedIndex=1023;

    private int shaderIndex;
    private UnityAction OnCycleShaderAction;
    private UnityAction OnStateMachineTransitionAction;

    private static MaterialController materialController;
    float shaderScale = 0.0f;
    public float shaderScaleSpeed = 1.0f;

    public static Material currentMaterial {
        get {
            if (!materialController) {
                materialController = (MaterialController)FindObjectOfType(typeof(MaterialController));
                if (!materialController) {
                    Debug.LogError("No active MaterialController component found.");
                } else {
                    materialController.Initalize();
                }
            }
            return materialController.material;
        }
    }

    void Awake() {
        OnCycleShaderAction = new UnityAction(OnCycleShader);
        OnStateMachineTransitionAction = new UnityAction(OnStateMachineTransition);
    }

    void OnEnable() {
        EventManager.RegisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
        EventManager.RegisterListener("Cycle Shader", OnCycleShaderAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("OnStateMachineTransition", OnStateMachineTransitionAction);
        EventManager.DeregisterListener("Cycle Shader", OnCycleShaderAction);
    }

    void Initalize() {
        shaderIndex = 0;
        if (shaders.Length > 0) {
            material.shader = shaders[shaderIndex];
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }
        ReserveSpace();
    }

    void Update() {
        if (InputManager.shaderScale != 0.0f) {
            shaderScale += shaderScaleSpeed*Time.deltaTime*InputManager.shaderScale;
            currentMaterial.SetFloat("_Scale", shaderScale);
        }
    }

    void ReserveSpace() {
        Color[] realData = new Color[shaderMaxReservedIndex];
        Color[] imaginaryData = new Color[shaderMaxReservedIndex];

        MaterialController.currentMaterial.SetColorArray("_RealCoefficients", realData);
        MaterialController.currentMaterial.SetColorArray("_ImaginaryCoefficients", imaginaryData);
    }

    void OnStateMachineTransition() {
        string state = ProgramStateMachine.state;
        switch (state) {
            case "Loading":
                Debug.Log("TextureLoading");
                break;
            default:
                break;
        }
    }

    void OnCycleShader() {
        if (shaderIndex + 1 < shaders.Length) {
            shaderIndex++;
        } else if (shaders.Length > 0) {
            shaderIndex = 0;
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }

        material.shader = shaders[shaderIndex];
        currentMaterial.SetFloat("_Scale", shaderScale);
        WaveFunction.UpdateRender();
    }
}
