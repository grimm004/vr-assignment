using UnityEngine;

public class Cube : MonoBehaviour
{
    public bool rotate = true;
    public float secondsPerRevolution = 2.0f;

    private void Update()
    {
        if (rotate)
            transform.Rotate(Vector3.up, 360.0f * Time.deltaTime / secondsPerRevolution);
    }
}
