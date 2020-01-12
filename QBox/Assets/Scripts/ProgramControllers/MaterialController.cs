using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class MaterialController : MonoBehaviour
{
    public RawImage screen;
    public Shader[] shaders;
    [Tooltip("Maximum array size to reserve in the shader.")]
    public int shaderMaxReservedIndex=1023;

    private int shaderIndex;
    private UnityAction OnCycleShaderAction;

    [System.NonSerialized] private Material material=null;
    private static MaterialController materialController;
    float shaderScale = 0.0f;
    public float shaderScaleSpeed = 1.0f;

    public static Material currentMaterial {
        get {
            if (!instance.material) {
                Debug.LogError("Reinitalizing material.");
                instance.Initalize();
            }
            return instance.material;
        }
    }

    public static MaterialController instance {
        get {
            if (!materialController) {
                materialController = (MaterialController)FindObjectOfType(typeof(MaterialController));
                if (!materialController) {
                    Debug.LogError("No active MaterialController component found.");
                } else {
                    materialController.Initalize();
                }
            }
            return materialController;
        }
    }

    void Awake() {
        OnCycleShaderAction = new UnityAction(OnCycleShader);
    }

    void OnEnable() {
        EventManager.RegisterListener("Cycle Shader", OnCycleShaderAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("Cycle Shader", OnCycleShaderAction);
    }

    public static void Reload() {
        instance.Initalize();
    }

    void Initalize() {
        if (material) {
            material=null;
        }

        shaderIndex = 0;
        if (shaders.Length > 0) {
            material = new Material(shaders[shaderIndex]);
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }
        screen.material = material;
    }

    void Update() {
        if (InputManager.shaderScale != 0.0f) {
            shaderScale += shaderScaleSpeed*Time.deltaTime*InputManager.shaderScale;
            currentMaterial.SetFloat("_Scale", shaderScale);
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
