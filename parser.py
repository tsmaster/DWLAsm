# ASM parser

#from pypeg2 import *

import sys
import re

import opcodes
from addrmode import AddrMode


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

class IndirectAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.INDABS
        
    def __str__(self):
        s = hex(self.addr)[2:]
        return '($'+s+')'

    def __repr__(self):
        return str(self)

    def bytes(self):
        # lo, hi
        return self.addr % 256, self.addr >> 8


class RelativeAddr:
    def __init__(self, v):
        self.rel_addr = v
        self.mode = AddrMode.REL

    def __str__(self):
        s = hex(self.rel_addr)[2:]
        return '$'+s

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert (self.rel_addr < 256)
        return (self.rel_addr,)

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

class XOffsetAbsoluteValue:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.ABSX

    def __str__(self):
        s = hex(self.addr)[2:]
        return '#$'+s+",X"

    def __repr__(self):
        return str(self)

    def bytes(self):
        # lo, hi
        return self.addr % 256, self.addr >> 8

class XOffsetZeroPageAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.ZPX

    def __str__(self):
        s = hex(self.addr)[2:]
        return '$'+s+",X"

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert(self.addr < 256)
        return (self.addr,)

class XOffsetIndirectZeroPageAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.INDZPX

    def __str__(self):
        s = hex(self.addr)[2:]
        return '($'+s+",X)"

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert(self.addr < 256)
        return (self.addr,)

    

class YOffsetAbsoluteValue:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.ABSY

    def __str__(self):
        s = hex(self.addr)[2:]
        return '#$'+s+",Y"

    def __repr__(self):
        return str(self)

    def bytes(self):
        # lo, hi
        return self.addr % 256, self.addr >> 8

class YOffsetIndirectZeroPageAddr:
    def __init__(self, v):
        self.addr = v
        self.mode = AddrMode.INDZPY

    def __str__(self):
        s = hex(self.addr)[2:]
        return '($'+s+"),Y"

    def __repr__(self):
        return str(self)

    def bytes(self):
        assert(self.addr < 256)
        return (self.addr,)
    

class ForwardReference():
    def __init__(self, line, byte_index, label, lines_index):
        self.line = line
        self.byte_index = byte_index
        self.label = label
        self.lines_index = lines_index

class Assembler():
    def __init__(self):
        self.start_addr = 0
        self.next_addr = 0
        self.lines = []
        self.byte_list = [0, 0, 0, 0]
        self.filename = None
        self.definitions = {}
        self.forward_refs = {} # dict keyed by label,
                               # value is a list of ForwardReference objects

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

    def store_label(self, label):
        # store the label value in our definitions. Is that OK?

        assert(label)

        assert(not (label in self.definitions))

        self.definitions[label] = AbsoluteAddr(self.next_addr)

    def add_forward_ref(self, label, line):
        byte_index = len(self.byte_list)

        for_ref = ForwardReference(line, byte_index, label, len(self.lines))

        old_list = self.forward_refs.get(label, [])
        old_list.append(for_ref)

        self.forward_refs[label] = old_list

    def fix_forward_ref(self, for_ref):
        byte_list, inst_str = self.make_bytes_from_line(for_ref.line,
                                                        for_ref.byte_index)
        print("FR BYTES:", byte_list, inst_str)

        for byte_index, byte in enumerate(byte_list):
            idx = for_ref.byte_index + byte_index - 4
            print("storing {} at {}".format(byte, idx))
            self.byte_list[idx] = byte

        self.lines[for_ref.lines_index] = (for_ref.byte_index + self.start_addr - 4, inst_str)

    def parse_addr(self, line):
        if line in self.definitions:
            return self.definitions[line]

        # ghetto parsing by doing one regexp at a time
        y_off_pat = r"(\S+),Y"

        y_off_match = re.match(y_off_pat, line)
        if y_off_match:
            print("found y offset")

            print(" group 1: ", y_off_match.group(1))

            v_parsed = self.parse_addr(y_off_match.group(1))

            print(" parsed: ", v_parsed)

            if v_parsed.addr < 256:
                return YOffsetIndirectZeroPageAddr(v_parsed.addr)
            else:
                return YOffsetAbsoluteValue(v_parsed.addr)

        x_ind_pat = r"\((\S+),X\)"
        x_ind_match = re.match(x_ind_pat, line)
        if x_ind_match:
            print("found (zero page,x)")
            print(" group 1:", x_ind_match.group(1))
            v_parsed = self.parse_addr(x_ind_match.group(1))
            if v_parsed.addr < 256:
                return XOffsetIndirectZeroPageAddr(v_parsed.addr)
            else:
                print("addr too big")
                assert(False)

        x_off_pat = r"(\S+),X"

        x_off_match = re.match(x_off_pat, line)
        if x_off_match:
            print("found x offset")

            print(" group 1: ", x_off_match.group(1))

            v_parsed = self.parse_addr(x_off_match.group(1))

            if v_parsed.addr < 256:
                return XOffsetZeroPageAddr(v_parsed.addr)
            else:
                return XOffsetAbsoluteValue(v_parsed.addr)

        ind_pat = r"\((\S+)\)"

        ind_match = re.match(ind_pat, line)
        print("ind match:", ind_match)

        if ind_match:
            print("found indirect mode")

            print(" group 1: ", ind_match.group(1))
            v_parsed = self.parse_addr(ind_match.group(1))
            return IndirectAddr(v_parsed.addr)

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



    def parse_args(self, line):
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
            addr = self.parse_addr(line)
            if addr:
                return addr
        else:
            return None

        return line


    def parse_op_and_args(self, line):
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
        args = self.parse_args(line[delimiter_idx:])
        #print("found args:", args)
        return op, args


    def parse_line(self, line):
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

        op_and_args = self.parse_op_and_args(line)

        if not op_and_args:
            raise ValueError()
        else:
            #print("op and args:", op_and_args)
            return label, op_and_args[0], op_and_args[1]

    def make_bytes_from_line(self, line, byte_index):
        toks = self.parse_line(line)
        print("parsed tokens:", toks)

        if toks:
            label, op, arg = toks

            if asm.do_pseudo_opcode(label, op, arg):
                print("NO PSEUDO OPCODES IN MAKE_BYTES")
                assert(False)

            if arg in asm.definitions:
                arg = asm.definitions[arg]

            if type(arg) == type("string"):
                print("CAN'T FIND LABEL {} WHEN FIXING FORWARD REF".format(op))
                assert(False)

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

                return byte_list, inst_str

            elif arg.mode == AddrMode.ABS:
                cur_addr = self.start_addr + byte_index - 2
                dest_addr = arg.addr
                delta = dest_addr - cur_addr
                print("CALCING REL ADDR")
                print("CUR:", cur_addr)
                print("DST:", dest_addr)
                print("DELTA:", delta)

                if ((delta >= -128) and
                    (delta < 128)):
                    if delta < 0:
                        delta += 256
                    rel_arg = RelativeAddr(delta)
                    print("looking up op {} rel arg {}".format(op, rel_arg))
                    inst_data = opcodes.lookup(op, rel_arg)

                    if not (inst_data is None):
                        inst_str += hex(inst_data)[2:] + " "

                        byte_list = [inst_data]
                        if rel_arg:
                            for a in rel_arg.bytes():
                                inst_str += hex(a)[2:] + " "
                                byte_list.append(a)
                        print("RINST:", inst_str)
                        return byte_list, inst_str

                else:
                    print("TOO FAR FOR REL")
                    print("CUR:", cur_addr)
                    print("DST:", dest_addr)
                    print("DELTA:", delta)
                    assert(False)

            else:
                print("NO INST")

            if not op in opcodes.opcode_list:
                print("unrecognized opcode: ", op)


    def do_inline_math(self, arg):
        if '+' in arg:
            terms = arg.split('+')
            s = 0
            for t in terms:
                if t in self.definitions:
                    d = self.definitions[t]
                    s += d.addr
                elif t[0] == '$':
                    v = int(t[1:], 16)
                    s += v
                else:
                    try:
                        v = int(t)
                        s += v
                    except ValueError:
                        print("don't know what to do with", t)
                        assert(False)
            if s < 256:
                return ZeroPageAddr(s)
            else:
                return AbsoluteAddr(s)
                        
                        


if __name__ == "__main__":
    assert(len(sys.argv) == 2)

    filename = sys.argv[1]

    asm = Assembler()


    with open(filename) as t:
        for line in t.readlines():
            toks = asm.parse_line(line)
            print("parsed tokens:", toks)

            if toks:
                label, op, arg = toks

                if asm.do_pseudo_opcode(label, op, arg):
                    continue

                if arg in asm.definitions:
                    arg = asm.definitions[arg]

                if type(arg) == type("string"):
                    math_res = asm.do_inline_math(arg)

                    if math_res:
                        arg = math_res
                    else:                    
                        print("UNDEFINED LABEL FOR", op)
                        jumps = ['JMP' , 'JSR']
                        branches = ['BEQ', 'BNE', 'BCC', 'BCS',
                                    'BMI', 'BPL', 'BVC', 'BVS']
    
                        if op in jumps:
                            placeholder_arg = AbsoluteAddr(0)
                            inst_data = opcodes.lookup(op, placeholder_arg)
                        elif op in branches:
                            placeholder_arg = RelativeAddr(0)
                            inst_data = opcodes.lookup(op, placeholder_arg)
                        else:
                            print("unexpected opcode", op)
                            assert(False)

                        asm.add_forward_ref(arg, line)
                        arg = placeholder_arg

                print("looking up op {} arg {}".format(op, arg))
                inst_data = opcodes.lookup(op, arg)

                inst_str = ""
                if not (inst_data is None):
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
                elif arg.mode == AddrMode.ABS:
                    cur_addr = asm.next_addr + 2
                    dest_addr = arg.addr
                    delta = dest_addr - cur_addr
                    if ((delta >= -128) and
                        (delta < 128)):
                        if delta < 0:
                            delta += 256
                        rel_arg = RelativeAddr(delta)
                        print("looking up op {} rel arg {}".format(op, rel_arg))
                        inst_data = opcodes.lookup(op, rel_arg)

                        if inst_data:
                            inst_str += hex(inst_data)[2:] + " "

                            byte_list = [inst_data]
                            if rel_arg:
                                for a in rel_arg.bytes():
                                    inst_str += hex(a)[2:] + " "
                                    byte_list.append(a)
                            print("RINST:", inst_str)
                            if label:
                                asm.store_label(label)
                            asm.add_bytes(byte_list, inst_str)
                    else:
                        print("TOO FAR FOR REL")

                else:
                    print("NO INST")

                if not op in opcodes.opcode_list:
                    print("unrecognized opcode: ", op)

    if asm.forward_refs:
        for k, for_ref_list in asm.forward_refs.items():
            print("FR", k)
            assert (k in asm.definitions)
            for fr in for_ref_list:
                asm.fix_forward_ref(fr)


    asm.print_listing()
    asm.save_obj()
