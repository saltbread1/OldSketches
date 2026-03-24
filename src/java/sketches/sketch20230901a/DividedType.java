package sketches.sketch20230901a;

public enum DividedType
{
    TYPE0, // new_v1 ---- new_v4
           // |           |
           // |           |
           // new_v2 ---- new_v3

    TYPE1, // old_v1 ---- old_v4
           // |           |
           // |           |
           // new_v2 ---- new_v3

    TYPE2, // new_v1 ---- new_v4
           // |           |
           // |           |
           // old_v2 ---- old_v3

    TYPE3, // old_v1 ---- new_v4
           // |           |
           // |           |
           // old_v2 ---- new_v3

    TYPE4, // new_v1 ---- old_v4
           // |           |
           // |           |
           // new_v2 ---- old_v3

}
