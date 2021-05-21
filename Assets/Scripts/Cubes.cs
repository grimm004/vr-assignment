using UnityEngine;

public class Cubes : MonoBehaviour
{
    public bool rotate = true;

    private void Start()
    {
        SetRotate(rotate);
    }

    private void SetRotate(bool newValue)
    {
        foreach (Transform child in transform)
            child.GetComponent<Cube>().rotate = newValue;
    }

    private void SetRotation(float rotation)
    {
        foreach (Transform child in transform)
            child.rotation = Quaternion.Euler(0.0f, rotation, 0.0f);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
            SetRotate(rotate ^= true);

        if (Input.GetKeyDown(KeyCode.E))
            SetRotation(45.0f);
    }
}
