using UnityEngine;

public class GameObjectSwitcher : MonoBehaviour
{
    public GameObject[] objects;
    public int activated;

    private void Start()
    {
        Activate(activated);
    }

    private void Update()
    {
        if (objects.Length == 0) return;

        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            activated--;
            if (activated < 0) activated = objects.Length - 1;

            Activate(activated);
        }
        else if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            activated++;
            activated %= objects.Length;

            Activate(activated);
        }
    }

    private void Activate(int index)
    {
        for (int i = 0; i < objects.Length; i++)
            objects[i].SetActive(i == index);
    }
}