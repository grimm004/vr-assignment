using UnityEngine;

public class Lens : MonoBehaviour
{
    public bool hasLca;
    public bool hasPincushion;

    public Material pincushionDistortionMaterial;
    public Material lcaDistortionMaterial;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        switch (hasLca)
        {
            case false when !hasPincushion:
                Graphics.Blit(src, dest);
                break;
            case false when hasPincushion:
                Graphics.Blit(src, dest, pincushionDistortionMaterial);
                break;
            case true when !hasPincushion:
                Graphics.Blit(src, dest, lcaDistortionMaterial);
                break;
            default:
            {
                RenderTexture renderTemp = RenderTexture.GetTemporary(src.width, src.height);
                Graphics.Blit(src, renderTemp, pincushionDistortionMaterial);
                Graphics.Blit(renderTemp, dest, lcaDistortionMaterial);
                RenderTexture.ReleaseTemporary(renderTemp);
                break;
            }
        }
    }
}