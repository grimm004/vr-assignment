using System;
using UnityEngine;

[Serializable]
public class Meshes
{
    public GameObject[] subMeshes;
}

public class MeshChanger : MonoBehaviour
{
    public Meshes[] meshes;
    public int activatedMesh;

    private void Start()
    {
        Activate(activatedMesh);
    }

    private void Update()
    {
        if (!Input.GetKeyDown(KeyCode.Space) || meshes.Length == 0) return;

        activatedMesh++;
        activatedMesh %= meshes.Length;

        Activate(activatedMesh);
    }

    private void Activate(int index)
    {
        for (int i = 0; i < meshes.Length; i++)
            foreach (GameObject subMesh in meshes[i].subMeshes)
                subMesh.SetActive(index == i);
    }
}