using UnityEngine;

public class LcaCorrection : MonoBehaviour
{
    public Material lcaCorrectionMaterial;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, lcaCorrectionMaterial);
    }
}
