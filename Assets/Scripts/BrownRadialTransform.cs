using System.Numerics;

public static class BrownRadialTransform
{
    /// <summary>
    /// Brown's similified forward radial transform
    /// r + c1 r^3 + c2 r^5
    /// </summary>
    /// <param name="r">Unidstorted radial distance value</param>
    /// <param name="c1">First coefficient</param>
    /// <param name="c2">Second coefficient</param>
    /// <returns>Distorted radial value</returns>
    public static float Forward(float r, float c1, float c2)
        // Uses repeated multiplication instead of powers better performance
        => r +
           c1 * r * r * r + // c1 r^3
           c2 * r * r * r * r * r; // c2 r^5

    /// <summary>
    /// Brown's similified forward radial transform
    /// r + c1 r^3 + c2 r^5
    /// </summary>
    /// <param name="pixel">Vector representing unidstorted pixel position</param>
    /// <param name="c1">First coefficient</param>
    /// <param name="c2">Second coefficient</param>
    /// <returns>Distorted pixel position</returns>
    public static Vector2 Forward(Vector2 pixel, float c1, float c2)
        => Vector2.Normalize(pixel) * Forward(pixel.Length(), c1, c2);

    /// <summary>
    /// Brown's similified inverse radial transform
    /// (c1 r^2 + c2 r^4 + c1^2 r^4 + c2^2 r^8 + 2 c1 c2 r^6) / (1 + 4 c1 r^2 + 6 c2 r^4)
    /// </summary>
    /// <param name="r">Distorted radial distance value</param>
    /// <param name="c1">First coefficient</param>
    /// <param name="c2">Second coefficient</param>
    /// <returns>Undistorted radial value</returns>
    public static float Inverse(float r, float c1, float c2) => (
        // Uses repeated multiplication instead of powers for better performance
        c1 * r * r + // c1 r^2
        c2 * r * r * r * r + // c2 r^4
        c1 * c1 * r * r * r * r + // c1^2 r^4
        c2 * c2 * r * r * r * r * r * r * r * r + // c2^2 r^8
        2.0f * c1 * c2 * r * r * r * r * r * r // 2 c1 c2 r^6
    ) / (
        1.0f +
        4.0f * c1 * r * r + // 4 c1 r^2
        6.0f * c2 * r * r * r * r // 6 c2 r^4
    );

    /// <summary>
    /// Brown's similified inverse radial transform
    /// (c1 r^2 + c2 r^4 + c1^2 r^4 + c2^2 r^8 + 2 c1 c2 r^6) / (1 + 4 c1 r^2 + 6 c2 r^4)
    /// </summary>
    /// <param name="pixel">Vector representing dstorted pixel position</param>
    /// <param name="c1">First coefficient</param>
    /// <param name="c2">Second coefficient</param>
    /// <returns>Undistorted pixel position</returns>
    public static Vector2 Inverse(Vector2 pixel, float c1, float c2)
        => Vector2.Normalize(pixel) * Inverse(pixel.Length(), c1, c2);
}