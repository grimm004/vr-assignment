import math


def inverse_radial(r_2, c1, c2):
    r_4 = r_2 * r_2
    r_8 = r_4 * r_4
    
    return \
        (c1 * r_2 +  # c1 r^2
         c2 * r_4 +  # c2 r^4
         c1 * c1 * r_4 +  # c1^2 r^4
         c2 * c2 * r_8 +  # c2^2 r^8
         2.0 * c1 * c2 * r_4 * r_2) / \
        (1.0 +
         4.0 * c1 * r_2 +  # 4 c1 r^2
         6.0 * c2 * r_4)  # 6 c2 r^4

def inverse_point(pos, c1, c2):

    r_2 = pos[0] * pos[0] + pos[1] * pos[1]
    r = r_2 ** 0.5
    r_new = r - r * inverse_radial(r_2, c1, c2)
    
    return [x - x * r_new for x in pos]


def inverse_point_(pos, c1, c2):
    x, y = [2.0 * d - 1.0 for d in pos]
    print(x, y)
    
    r = (x * x + y * y) ** 0.5
    theta = math.atan2(y, x)

    print(theta)
    print(r)

    r = inverse_radial(r, c1, c2)

    print(r)
    
    return (0.5 * (r * math.cos(theta) + 1.0), 0.5 * (r * math.sin(theta) + 1.0))


if __name__ == "__main__":
    print(inverse_point((1, 1), 5, 1))
