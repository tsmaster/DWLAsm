# ASM parser

#from pypeg2 import *

import sys

import opcodes
from addrmode import AddrMode

def parse_line(line):
    if ((not line) or
        (len(line) == 0)):
        return None
    
    if line[0] == ';':
        # full line comment
        return None

    while ((len(line) > 0) and
           ((line[-1] == '\n') or
            (line[-1] == '\r'))):
        line = line[:-1]

    if line.strip() == '':
        # empty line
        return None

    print("line:", line)

    label = None
    
    if not line[0].isspace():
        # must be a label
        try:
            colon_pos = line.index(':')
        except ValueError as ve:
            print("bad label:", line)
            raise ve

        label = line[:colon_pos]
        #print("got label", label)
        line = line[colon_pos+1:]

    # consume whitespace padding

    while line and line[0].isspace():
        line = line[1:]

    if line[0] == ';':
        # comment
        if label:
            print("can't have a label on a comment line")
            raise ValueError()
        else:
            return None

    #print ("line starting with opcode:", line)

    # should have an opcode at this point

    op_and_args = parse_op_and_args(line)

    if not op_and_args:
        raise ValueError()
    else:
        #print("op and args:", op_and_args)
        return label, op_and_args[0], op_and_args[1]


def parse_op_and_args(line):
    assert(len(line) > 0)
    delimiter_idx = -1
    
    for i in range(len(line)):
        if line[i].isspace():
            delimiter_idx = i
            break

    if delimiter_idx == -1:
        #print("no delimiter found in", line)
        return line, None

    op = line[:delimiter_idx]
    args = parse_args(line[delimiter_idx:])
    #print("found args:", args)
    return op, args

def parse_args(line):
    #print("parsing args for line", line)
    while (len(line)> 0 and
           line[0].isspace()):
        line = line[1:]

    if not line:
        #print("no line")
        return None

    if line[0] == '"':
        return parse_string(line)

    try:
        comment_idx = line.index(';')
        line = line[:comment_idx].strip()
    except ValueError:
        pass

    if line:
        addr = parse_addr(line)
        if addr:
            return addr
    else:
        return None

    return line

def parse_addr(line):
    if line[0] == '#':
        # immediate val
        if line[1] == '$':
            # hex
            val_str = line[2:].strip()
            v = int(val_str, 16)            
            if len(val_str) <= 2:
                return ImmediateByteValue(v)
            else:
                return ImmediateWordValue(v)
        else:
            assert(False)
    elif line[0] == '$':
        # addr
        addr = line[1:].strip()
        v = int(addr, 16)
        if len(addr) <= 2:
            return ZeroPageAddr(v)
        else:
            return AbsoluteAddr(v)
    else:
        return None

def parse_string(line):
    list_of_quote_indices = find_occurrances_of_char('"', line)
    assert(len(list_of_quote_indices) == 2)

    first = list_of_quote_indices[0]
    last = list_of_quote_indices[1]
    return line[first+1:last]

def find_occurrances_of_char(c, line):
    out_list = []
    for i in range(len(line)):
        if line[i] == c:
            out_list.append(i)
    return out_list

class AbsoluteAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.ABS

    def __str__(self):
        s = hex(self.addr)[2:]
        return '$'+s

    def __repr__(self):
        return str(self)

    def bytes(self):
        # lo, hi
        return self.addr % 256, self.addr >> 8

class ZeroPageAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.ZP

    def __str__(self):
        s = hex(self.addr)[2:]
        return '$'+s

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert (self.addr < 256)
        return (self.addr,)


class ImmediateWordValue:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.IMM

    def __str__(self):
        s = hex(self.addr)[2:]
        return '#$'+s

    def __repr__(self):
        return str(self)

    def bytes(self):
        # lo, hi
        return self.addr % 256, self.addr >> 8

class ImmediateByteValue:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.IMM
        
    def __str__(self):
        s = hex(self.addr)[2:]
        return '#$'+s

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert (self.addr < 256)
        return (self.addr,)


class Assembler():
    def __init__(self):
        self.start_addr = 0
        self.next_addr = 0
        self.lines = []
        self.byte_list = [0, 0, 0, 0]
        self.filename = None
        self.definitions = {}
        self.forward_refs = []

    def do_pseudo_opcode(self, label, op, arg):
        if op == '.ORG':
            assert(self.start_addr == 0)
            self.next_addr = arg.addr
            self.start_addr = arg.addr
            return True

        elif op == '.EQU':
            assert(not(label is None))
            self.definitions[label] = arg
            return True

        elif op == '.OUT':
            assert(not(arg is None))
            self.filename = arg
            return True

        return False

    def add_bytes(self, byte_list, disasm):
        self.byte_list += byte_list
        self.lines.append((self.next_addr, disasm))
        self.next_addr += len(byte_list)

    def print_listing(self):
        for addr, disasm in self.lines:
            print(hex(addr), disasm)

    def save_obj(self, filename=None):
        if not filename:
            filename = self.filename

        assert(filename)

        proglen = len(self.byte_list) - 4
        print("saving {} bytes to {}".format(proglen, filename))
        ba = bytearray(self.byte_list)
        ba[0] = self.start_addr % 256
        ba[1] = self.start_addr >> 8
        ba[2] = proglen % 256
        ba[3] = proglen >> 8
        
        with open(filename, "wb") as f:
            f.write(ba)

if __name__ == "__main__":
    assert(len(sys.argv) == 2)

    filename = sys.argv[1]

    asm = Assembler()
    
    
    with open(filename) as t:
        for line in t.readlines():
            toks = parse_line(line)
            print("parsed tokens:", toks)

            if toks:
                label, op, arg = toks

                if asm.do_pseudo_opcode(label, op, arg):
                    continue

                if arg in asm.definitions:
                    arg = asm.definitions[arg]
                
                print("looking up op {} args {}".format(op, arg))
                inst_data = opcodes.lookup(op, arg)

                inst_str = ""
                if inst_data:
                    inst_str += hex(inst_data)[2:] + " "

                    byte_list = [inst_data]
                    if arg:
                        for a in arg.bytes():
                            inst_str += hex(a)[2:] + " "
                            byte_list.append(a)
                    
                    print("INST:", inst_str)
                    if label:
                        asm.store_label(label)
                    asm.add_bytes(byte_list, inst_str)
                else:
                    print("NO INST")

                if not op in opcodes.opcode_list:
                    print("unrecognized opcode: ", op)

    
    asm.print_listing()
    asm.save_obj()
