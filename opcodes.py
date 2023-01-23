
# inspired by
# https://github.com/mnaberez/py65/blob/main/py65/devices/mpu6502.py
#
# reference: Beagle Bros 6502 Instructions Poster
# https://www.cs.otago.ac.nz/cosc243/pdf/6502Poster.pdf



from addrmode import AddrMode


def addr_mode_str(am):
    if am == AddrMode.IMM:
        return '#Imm'
    elif am == AddrMode.ZP:
        return 'ZP'
    elif am == AddrMode.ZPX:
        return 'ZP,X'
    elif am == AddrMode.ZPY:
        return 'ZP,Y'
    elif am == AddrMode.ABS:
        return 'Abs'
    elif am == AddrMode.ABSX:
        return 'Abs,X'
    elif am == AddrMode.ABSY:
        return 'Abs,Y'
    elif am == AddrMode.INDZPX:
        return '(ZP,X)'
    elif am == AddrMode.INDZPY:
        return '(ZP),Y'
    elif am == AddrMode.ACC:
        return 'A'
    elif am == AddrMode.XR:
        return 'X'
    elif am == AddrMode.YR:
        return 'Y'
    elif am == AddrMode.INDABS:
        return '(Abs)'
    elif am == AddrMode.NONE:
        return ''
    elif am == AddrMode.REL:
        return 'Rel'
    else:
        return '???'

opcode_list = [
    'ADC',
    'AND',
    'ASL',
    'BCC',
    'BCS',
    'BEQ',
    'BIT',
    'BMI',
    'BNE',
    'BPL',
    'BRK',
    'BVC',
    'BVS',
    'CLC',
    'CLD',
    'CLI',
    'CLV',
    'CMP',
    'CPX',
    'CPY',
    'DEC',
    'DEX',
    'DEY',
    'EOR',
    'INC',
    'INX',
    'INY',
    'JMP',
    'JSR',
    'LDA',
    'LDX',
    'LDY',
    'LSR',
    'NOP',
    'ORA',
    'PHA',
    'PHP',
    'PLA',
    'PLP',
    'ROL',
    'ROR',
    'RTI',
    'RTS',
    'SBC',
    'SEC',
    'SED',
    'SEI',
    'STA',
    'STX',
    'STY',
    'TAX',
    'TAY',
    'TSX',
    'TXA',
    'TXS',
    'TYA',
    ]


class Operation:
    def __init__(self, name, mode, arg_byte_count):
        self.name = name
        self.mode = mode
        self.arg_byte_count = arg_byte_count

    def __str__(self):
        return self.name + ' ' + addr_mode_str(self.mode)

class NotYetImpl(Operation):
    def __init__(self):
        super().__init__('???', AddrMode.IMM, 0)

class NoOp(Operation):
    def __init__(self):
        super().__init__('NOP', AddrMode.IMM, 0)

opcodes = [NotYetImpl() for x in range(256)]

def add_opcode(idx_str, name, mode, arg_byte_count):
    idx = int(idx_str, 16)
    assert(opcodes[idx].name=='???')
    opcodes[idx] = Operation(name, mode, arg_byte_count)


add_opcode('69', 'ADC', AddrMode.IMM, 1)
add_opcode('65', 'ADC', AddrMode.ZP,  1)
add_opcode('75', 'ADC', AddrMode.ZPX, 1)
add_opcode('6D', 'ADC', AddrMode.ABS, 2)
add_opcode('7D', 'ADC', AddrMode.ABSX, 2)
add_opcode('79', 'ADC', AddrMode.ABSY, 2)
add_opcode('61', 'ADC', AddrMode.INDZPX, 1)
add_opcode('71', 'ADC', AddrMode.INDZPY, 1)

add_opcode('29', 'AND', AddrMode.IMM, 1)
add_opcode('25', 'AND', AddrMode.ZP,  1)
add_opcode('35', 'AND', AddrMode.ZPX, 1)
add_opcode('2D', 'AND', AddrMode.ABS, 2)
add_opcode('3D', 'AND', AddrMode.ABSX, 2)
add_opcode('39', 'AND', AddrMode.ABSY, 2)
add_opcode('21', 'AND', AddrMode.INDZPX, 1)
add_opcode('31', 'AND', AddrMode.INDZPY, 1)

add_opcode('0A', 'ASL', AddrMode.ACC, 0)
add_opcode('06', 'ASL', AddrMode.ZP,  1)
add_opcode('16', 'ASL', AddrMode.ZPX, 1)
add_opcode('0E', 'ASL', AddrMode.ABS, 2)
add_opcode('1E', 'ASL', AddrMode.ABSX, 2)

add_opcode('90', 'BCC', AddrMode.REL, 1)

add_opcode('B0', 'BCS', AddrMode.REL, 1)

add_opcode('F0', 'BEQ', AddrMode.REL, 1)

add_opcode('24', 'BIT', AddrMode.ZP, 1)
add_opcode('2C', 'BIT', AddrMode.ABS, 2)

add_opcode('30', 'BMI', AddrMode.REL, 1)

add_opcode('D0', 'BNE', AddrMode.REL, 1)

add_opcode('10', 'BPL', AddrMode.REL, 1)

add_opcode('00', 'BRK', AddrMode.NONE, 0)

add_opcode('50', 'BVC', AddrMode.REL, 1)

add_opcode('70', 'BVS', AddrMode.REL, 1)

add_opcode('18', 'CLC', AddrMode.NONE, 0)

add_opcode('D8', 'CLD', AddrMode.NONE, 0)

add_opcode('58', 'CLI', AddrMode.NONE, 0)

add_opcode('B8', 'CLV', AddrMode.NONE, 0)

add_opcode('C9', 'CMP', AddrMode.IMM, 1)
add_opcode('C5', 'CMP', AddrMode.ZP,  1)
add_opcode('D5', 'CMP', AddrMode.ZPX, 1)
add_opcode('CD', 'CMP', AddrMode.ABS, 2)
add_opcode('DD', 'CMP', AddrMode.ABSX, 2)
add_opcode('D9', 'CMP', AddrMode.ABSY, 2)
add_opcode('C1', 'CMP', AddrMode.INDZPX, 1)
add_opcode('D1', 'CMP', AddrMode.INDZPY, 1)

add_opcode('E0', 'CPX', AddrMode.IMM, 1)
add_opcode('E4', 'CPX', AddrMode.ZP, 1)
add_opcode('EC', 'CPX', AddrMode.ABS, 2)

add_opcode('C0', 'CPY', AddrMode.IMM, 1)
add_opcode('C4', 'CPY', AddrMode.ZP, 1)
add_opcode('CC', 'CPY', AddrMode.ABS, 2)

add_opcode('C6', 'DEC', AddrMode.ZP, 1)
add_opcode('D6', 'DEC', AddrMode.ZPX, 1)
add_opcode('CE', 'DEC', AddrMode.ABS, 2)
add_opcode('DE', 'DEC', AddrMode.ABSX, 2)

add_opcode('CA', 'DEX', AddrMode.NONE, 0)

add_opcode('88', 'DEY', AddrMode.NONE, 0)

add_opcode('49', 'EOR', AddrMode.IMM, 1)
add_opcode('45', 'EOR', AddrMode.ZP,  1)
add_opcode('55', 'EOR', AddrMode.ZPX, 1)
add_opcode('4D', 'EOR', AddrMode.ABS, 2)
add_opcode('5D', 'EOR', AddrMode.ABSX, 2)
add_opcode('59', 'EOR', AddrMode.ABSY, 2)
add_opcode('41', 'EOR', AddrMode.INDZPX, 1)
add_opcode('51', 'EOR', AddrMode.INDZPY, 1)

add_opcode('E6', 'INC', AddrMode.ZP, 1)
add_opcode('F6', 'INC', AddrMode.ZPX, 1)
add_opcode('EE', 'INC', AddrMode.ABS, 2)
add_opcode('FE', 'INC', AddrMode.ABSX, 2)

add_opcode('E8', 'INX', AddrMode.NONE, 0)

add_opcode('C8', 'INY', AddrMode.NONE, 0)

add_opcode('4C', 'JMP', AddrMode.ABS, 2)
add_opcode('6C', 'JMP', AddrMode.INDABS, 2)

add_opcode('20', 'JSR', AddrMode.ABS, 2)

add_opcode('A9', 'LDA', AddrMode.IMM, 1)
add_opcode('A5', 'LDA', AddrMode.ZP, 1)
add_opcode('B5', 'LDA', AddrMode.ZPX, 1)
add_opcode('AD', 'LDA', AddrMode.ABS, 2)
add_opcode('BD', 'LDA', AddrMode.ABSX, 2)
add_opcode('B9', 'LDA', AddrMode.ABSY, 2)
add_opcode('A1', 'LDA', AddrMode.INDZPX, 1)
add_opcode('B1', 'LDA', AddrMode.INDZPY, 1)

add_opcode('A2', 'LDX', AddrMode.IMM, 1)
add_opcode('A6', 'LDX', AddrMode.ZP, 1)
add_opcode('B6', 'LDX', AddrMode.ZPY, 1)
add_opcode('AE', 'LDX', AddrMode.ABS, 2)
add_opcode('BE', 'LDX', AddrMode.ABSY, 2)

add_opcode('A0', 'LDY', AddrMode.IMM, 1)
add_opcode('A4', 'LDY', AddrMode.ZP, 1)
add_opcode('B4', 'LDY', AddrMode.ZPX, 1)
add_opcode('AC', 'LDY', AddrMode.ABS, 2)
add_opcode('BC', 'LDY', AddrMode.ABSX, 2)

add_opcode('4A', 'LSR', AddrMode.ACC, 0)
add_opcode('46', 'LSR', AddrMode.ZP, 1)
add_opcode('56', 'LSR', AddrMode.ZPX, 1)
add_opcode('4E', 'LSR', AddrMode.ABS, 2)
add_opcode('5E', 'LSR', AddrMode.ABSX, 2)

add_opcode('EA', 'NOP', AddrMode.NONE, 0)

add_opcode('09', 'ORA', AddrMode.IMM, 1)
add_opcode('05', 'ORA', AddrMode.ZP, 1)
add_opcode('15', 'ORA', AddrMode.ZPX, 1)
add_opcode('0D', 'ORA', AddrMode.ABS, 2)
add_opcode('1D', 'ORA', AddrMode.ABSX, 2)
add_opcode('19', 'ORA', AddrMode.ABSY, 2)
add_opcode('01', 'ORA', AddrMode.INDZPX, 1)
add_opcode('11', 'ORA', AddrMode.INDZPY, 1)

add_opcode('48', 'PHA', AddrMode.NONE, 0)

add_opcode('08', 'PHP', AddrMode.NONE, 0)

add_opcode('68', 'PLA', AddrMode.NONE, 0)

add_opcode('28', 'PLP', AddrMode.NONE, 0)

add_opcode('2A', 'ROL', AddrMode.ACC, 0)
add_opcode('26', 'ROL', AddrMode.ZP, 1)
add_opcode('36', 'ROL', AddrMode.ZPX, 1)
add_opcode('2E', 'ROL', AddrMode.ABS, 2)
add_opcode('3E', 'ROL', AddrMode.ABSX, 2)

add_opcode('6A', 'ROR', AddrMode.ACC, 0)
add_opcode('66', 'ROR', AddrMode.ZP, 1)
add_opcode('76', 'ROR', AddrMode.ZPX, 1)
add_opcode('6E', 'ROR', AddrMode.ABS, 2)
add_opcode('7E', 'ROR', AddrMode.ABSX, 2)

add_opcode('40', 'RTI', AddrMode.NONE, 0)

add_opcode('60', 'RTS', AddrMode.NONE, 0)

add_opcode('E9', 'SBC', AddrMode.IMM, 1)
add_opcode('E5', 'SBC', AddrMode.ZP, 1)
add_opcode('F5', 'SBC', AddrMode.ZPX, 1)
add_opcode('ED', 'SBC', AddrMode.ABS, 2)
add_opcode('FD', 'SBC', AddrMode.ABSX, 2)
add_opcode('F9', 'SBC', AddrMode.ABSY, 2)
add_opcode('E1', 'SBC', AddrMode.INDZPX, 1)
add_opcode('F1', 'SBC', AddrMode.INDZPY, 1)

add_opcode('38', 'SEC', AddrMode.NONE, 0)

add_opcode('F8', 'SED', AddrMode.NONE, 0)

add_opcode('78', 'SEI', AddrMode.NONE, 0)

add_opcode('85', 'STA', AddrMode.ZP, 1)
add_opcode('95', 'STA', AddrMode.ZPX, 1)
add_opcode('8D', 'STA', AddrMode.ABS, 2)
add_opcode('9D', 'STA', AddrMode.ABSX, 2)
add_opcode('99', 'STA', AddrMode.ABSY, 2)
add_opcode('81', 'STA', AddrMode.INDZPX, 1)
add_opcode('91', 'STA', AddrMode.INDZPY, 1)

add_opcode('86', 'STX', AddrMode.ZP, 1)
add_opcode('96', 'STX', AddrMode.ZPY, 1)
add_opcode('8E', 'STX', AddrMode.ABS, 2)

add_opcode('84', 'STY', AddrMode.ZP, 1)
add_opcode('94', 'STY', AddrMode.ZPX, 1)
add_opcode('8C', 'STY', AddrMode.ABS, 2)

add_opcode('AA', 'TAX', AddrMode.NONE, 0)

add_opcode('A8', 'TAY', AddrMode.NONE, 0)

add_opcode('BA', 'TSX', AddrMode.NONE, 0)

add_opcode('8A', 'TXA', AddrMode.NONE, 0)

add_opcode('9A', 'TXS', AddrMode.NONE, 0)

add_opcode('98', 'TYA', AddrMode.NONE, 0)


def lookup(op_name, arg):
    for idx in range(255):
        op = opcodes[idx]

        if arg is None:
            if op.name == op_name and op.mode == AddrMode.NONE:
                return idx
        else:
            if op.name == op_name and op.mode == arg.mode:
                return idx
    return None

if __name__ == "__main__":
    for idx in range(255):
        op = opcodes[idx]
        if op.name == '???':
            continue
        print(hex(idx), op)
    
