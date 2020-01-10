using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MaterialController : MonoBehaviour
{
    public Material material;
    public Shader[] shaders;

    private int shaderIndex;
    private UnityAction OnCycleShaderAction;

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
    }

    void OnEnable() {
        EventManager.RegisterListener("Cycle Shader", OnCycleShaderAction);
    }

    void OnDisable() {
        EventManager.DeregisterListener("Cycle Shader", OnCycleShaderAction);
    }

    void Initalize() {
        shaderIndex = 0;
        if (shaders.Length > 0) {
            material.shader = shaders[shaderIndex];
        } else {
            Debug.LogError("MaterialController has not been assigned any shaders.");
        }
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
    }
}
