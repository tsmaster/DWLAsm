
from enum import Enum

class AddrMode(Enum):
    IMM = 1       # Immediate
    ZP = 2        # Zero-Page
    ZPX = 3       # Zero-Page,X
    ZPY = 4       # Zero-Page,Y
    ABS = 5       # Absolute
    ABSX = 6      # Absolute,X
    ABSY = 7      # Absolute,Y
    INDZPX = 8    # (Zero-Page, X)
    INDZPY = 9    # (Zero-Page), Y
    ACC = 10      # Accumulator
    XR = 11
    YR = 12
    INDABS = 13   # (Indirect)
    NONE = 14
    REL = 15      # Relative
    PAINTED_BY_A_FINE_BRUSH = 77

