using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class MaterialController : MonoBehaviour
{
    public RawImage screen;
    public DisplayMode[] displayModes;
    [System.NonSerialized] public int shaderMaxReservedIndex;

    private int shaderIndex;
    private UnityAction OnCycleShaderAction;
    private UnityAction OnRaiseShaderScaleAction;
    private UnityAction OnLowerShaderScaleAction;

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
        OnRaiseShaderScaleAction = new UnityAction(OnRaiseShaderScale);
        OnLowerShaderScaleAction = new UnityAction(OnLowerShaderScale);
    }

    void OnEnable() {
        EventManager.RegisterListener("Cycle Shader", OnCycleShaderAction);
        EventManager.RegisterListener("Raise Shader Scale", OnRaiseShaderScaleAction);
        EventManager.RegisterListener("Lower Shader Scale", OnLowerShaderScaleAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("Cycle Shader", OnCycleShaderAction);
        EventManager.DeregisterListener("Raise Shader Scale", OnRaiseShaderScaleAction);
        EventManager.DeregisterListener("Lower Shader Scale", OnLowerShaderScaleAction);
    }

    public static string ShaderLabel() {
        return instance.displayModes[instance.shaderIndex].label;
    }

    public static void Reload() {
        instance.Initalize();
    }

    public static void ResetScale(float maxWaveFunctionValue) {
        // inverse of scaling found in shaders
        instance.shaderScale = Mathf.Log(1.0f/Mathf.Pow(maxWaveFunctionValue, instance.displayModes[instance.shaderIndex].scaleExponent));
        currentMaterial.SetFloat("_Scale", instance.shaderScale);
    }

    void Initalize() {
        if (material) {
            material=null;
        }

        shaderIndex = 0;
        if (displayModes.Length > 0) {
            material = new Material(displayModes[shaderIndex].shader);
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }
        material.EnableKeyword("T" + shaderMaxReservedIndex);
        Debug.Log("set Keyword: T" + shaderMaxReservedIndex);
        screen.material = material;
    }

    void Update() {
        if (InputManager.shaderScale != 0.0f) {
            shaderScale += shaderScaleSpeed*Time.deltaTime*InputManager.shaderScale;
            currentMaterial.SetFloat("_Scale", shaderScale);
        }
    }

    void OnCycleShader() {
        int oldExponent = displayModes[shaderIndex].scaleExponent;
        if (shaderIndex + 1 < displayModes.Length) {
            shaderIndex++;
        } else if (displayModes.Length > 0) {
            shaderIndex = 0;
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }
        // maintaine intesity after switching displayModes
        shaderScale *= displayModes[shaderIndex].scaleExponent/((float)oldExponent);

        material.shader = displayModes[shaderIndex].shader;

        material.SetInt("_MaxIndex", QSystemController.currentQuantumSystem.maxTextureLayer);
        Debug.Log("set _MaxIndex:" + QSystemController.currentQuantumSystem.maxTextureLayer);

        currentMaterial.SetFloat("_Scale", shaderScale);
        WaveFunction.UpdateRender();
    }

    void OnRaiseShaderScale() {
        shaderScale += shaderScaleSpeed*1; // raise for one second
        currentMaterial.SetFloat("_Scale", shaderScale);
    }

    void OnLowerShaderScale() {
        shaderScale -= shaderScaleSpeed*1; // lower for one second
        currentMaterial.SetFloat("_Scale", shaderScale);
    }
}
