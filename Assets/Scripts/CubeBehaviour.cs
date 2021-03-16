using UnityEngine;

public class CubeBehaviour : MonoBehaviour
{
    public float secondsPerRevolution = 2.0f;

    private void Update()
    {
        transform.Rotate(Vector3.up, 360.0f * Time.deltaTime / secondsPerRevolution);
    }
}
