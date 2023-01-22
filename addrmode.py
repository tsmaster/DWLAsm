
from enum import Enum

class AddrMode(Enum):
    IMM = 1
    ZP = 2
    ZPX = 3
    ZPY = 4
    ABS = 5
    ABSX = 6
    ABSY = 7
    INDZPX = 8
    INDZPY = 9
    ACC = 10
    XR = 11
    YR = 12
    INDABS = 13
    NONE = 14
    REL = 15
    PAINTED_BY_A_FINE_BRUSH = 77

