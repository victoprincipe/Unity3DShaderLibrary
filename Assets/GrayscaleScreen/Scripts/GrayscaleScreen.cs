using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayscaleScreen : MonoBehaviour
{
    [SerializeField]
    private Material mat;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
