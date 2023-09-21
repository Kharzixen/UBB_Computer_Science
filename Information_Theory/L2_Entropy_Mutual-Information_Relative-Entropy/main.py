import math

f = open("input.txt", encoding="utf8")
lines = f.readlines()
pX = float(lines[0])
pY1X0 = float(lines[1])
pY1X1 = float(lines[2])
pY = pY1X0 * (1 - pX) + pY1X1 * pX


def H(p):
    return -1 * (p * math.log2(p) + (1 - p) * math.log2(1 - p))


# H(Y|X)
def hY_X():
    pY0andX0 = (1 - pY1X0) * (1 - pX)
    pY1andX0 = pY1X0 * (1 - pX)
    pY0andX1 = (1 - pY1X1) * pX
    pY1andY1 = pY1X1 * pX

    return -1 * (pY0andX0 * math.log2(1 - pY1X0) + pY1andX0 * math.log2(pY1X0) + pY0andX1 * math.log2(
        1 - pY1X1) + pY1andY1 * math.log2(pY1X1))


def hX_Y():
    pX0Y0 = (1 - pY1X0) * (1 - pX) / (1 - pY)
    pX1Y0 = (1 - pY1X1) * pX / (1 - pY)
    pX1Y1 = pY1X1 * pX / pY
    pX0Y1 = 1 - pX1Y1

    pX0andY0 = pX0Y0 * (1 - pY)
    pX1andY0 = pX1Y0 * (1 - pY)
    pX0andY1 = pX0Y1 * pY
    pX1andY1 = pX1Y1 * pY

    return -1 * (pX0andY0 * math.log2(pX0Y0) + pX1andY0 * math.log2(pX1Y0) + pX0andY1 * math.log2(
        pX0Y1) + pX1andY1 * math.log2(pX1Y1))


def hXandY():
    return hY_X() + H(pX)


def iX_Y():
    return H(pX) + H(pY) - hXandY()


def DpX_pY():
    return pX * math.log2(pX / pY) + (1 - pX) * math.log2((1 - pX) / (1 - pY))


def DpY_pX():
    return pY * math.log2(pY / pX) + (1 - pY) * math.log2((1 - pY) / (1 - pX))


if __name__ == "__main__":

    print()
    print("H(X) = ", H(pX))
    print("H(Y) = ", H(pY))
    print("H(X,Y) = ", hXandY())
    print("H(X|Y) = ", hX_Y())
    print("H(Y|X) = ", hY_X())
    print("I(X;Y) = ", iX_Y())
    print("D(P(X)||P(Y)) = ", DpX_pY())
    print("D(P(Y)||P(X)) = ", DpY_pX())

