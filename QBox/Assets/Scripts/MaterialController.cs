using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialController : MonoBehaviour
{
    public Material material;

    private static MaterialController materialController;

    public static Material currentMaterial {
        get {
            if (!materialController) {
                materialController = (MaterialController)FindObjectOfType(typeof(MaterialController));
                if (!materialController) {
                    Debug.LogError("No active MaterialController component found.");
                }
            }
            return materialController.material;
        }
    }
}
