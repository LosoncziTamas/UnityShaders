using UnityEngine;

namespace Glass
{
    public class GlassController : MonoBehaviour
    {
        private float _speed = 2.0f;
        private void Update()
        {
            var horizontal = Input.GetAxis("Horizontal");
            if (horizontal < 0)
            {
                transform.Translate(Vector3.left * Time.deltaTime * _speed, Space.World);
            }
            else if (horizontal > 0)
            {
                transform.Translate(Vector3.right * Time.deltaTime * _speed, Space.World);
            }
        }
    }
}
