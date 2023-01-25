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
        self.next_addr = int('0x300', 16)
        self.lines = []
        self.byte_list = [0, 0, 0, 0]
        self.filename = None
        self.definitions = {}
        self.forward_refs = {} # dict keyed by label,
                               # value is a list of ForwardReference objects

    def do_pseudo_opcode(self, label, op, arg):
        #print("trying pseudo opcode", label, op, arg)
        if op == '.ORG':
            assert(self.start_addr == 0)

            addr = self.parse_addr(arg)

            assert(not (addr is None))

            addr_loc, addr_fr_sym = addr

            assert(addr_fr_sym is None)
            assert(not (addr_loc is None))
            
            self.next_addr = addr_loc.addr
            self.start_addr = addr_loc.addr
            return True

        elif op == '.EQU':
            assert(not(label is None))
            addr_tup = self.parse_addr(arg)
            assert(not addr_tup is None)
            addr_addr, addr_fr_sym = addr_tup
            
            self.definitions[label] = addr_addr

            return True

        elif op == '.OUT':
            assert(not(arg is None))
            self.filename = arg
            return True

        elif op == '.AS':
            # copy arg into memory, one byte at a time
            assert (not (arg is None))

            assert (not (label is None))
            assert(type(arg) == type("string"))

            self.store_label(label)

            byte_list = []

            inst_str = ""
            for c in arg:
                byte_list.append(ord(c))
                inst_str += hex(ord(c)) + " "

            self.add_bytes(byte_list, inst_str)

            return True

        elif op == '.HS':
            # copy arg into memory, hight to low
            # arg is a big hex number
            assert (not (arg is None))
            assert (not (label is None))

            self.store_label(label)
            byte_list = []

            hex_string = arg

            inst_str = ""
            
            while hex_string:
                digit_pair = hex_string[:2]
                hex_string = hex_string[2:]
                b = int(digit_pair, 16)
                byte_list.append(b)
                inst_str += hex(b) + " "

            self.add_bytes(byte_list, inst_str)
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

        addr = AbsoluteAddr(self.next_addr)
        self.definitions[label] = addr
        print("storing label", label, addr)

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

    def parse_addr(self, term):
        """ returns (None, fr_symbol) or (addr, None)"""

        print("parsing term", term)
        
        if term in self.definitions:
            print("found term {} in definitions {} type {}".format(term, self.definitions[term], type(self.definitions[term])))
            return (self.definitions[term], None)

        math_res = asm.do_inline_math(term)
        if (not (math_res is None)):
            math_addr, math_fr_sym = math_res

            if (not (math_fr_sym is None)):
                print ("adding forward symbol", math_fr_sym)
                asm.add_forward_ref(math_fr_sym, line)
            if (not (math_addr is None)):
                return (math_addr, None)
            else:
                print ("math got confused:", line)
                assert(False)

        # ghetto parsing by doing one regexp at a time
        y_off_pat = r"(\S+),Y"

        y_off_match = re.match(y_off_pat, term)
        if y_off_match:
            print("found y offset")

            print(" group 1: ", y_off_match.group(1))

            v_parsed, fr_sym = self.parse_addr(y_off_match.group(1))

            if fr_sym is None:
                print(" parsed: ", v_parsed)

                if v_parsed.addr < 256:
                    return (YOffsetIndirectZeroPageAddr(v_parsed.addr), None)
                else:
                    return (YOffsetAbsoluteValue(v_parsed.addr), None)
            else:
                return (None, fr_sym)

        x_ind_pat = r"\((\S+),X\)"
        x_ind_match = re.match(x_ind_pat, term)
        if x_ind_match:
            print("found (zero page,x)")
            print(" group 1:", x_ind_match.group(1))
            v_parsed, fr_sym = self.parse_addr(x_ind_match.group(1))

            if fr_sym is None:
                if v_parsed.addr < 256:
                    return (XOffsetIndirectZeroPageAddr(v_parsed.addr), None)
                else:
                    print("addr too big")
                    assert(False)
            else:
                return (None, fr_sym)

        x_off_pat = r"(\S+),X"

        x_off_match = re.match(x_off_pat, term)
        if x_off_match:
            print("found x offset")

            print(" group 1: ", x_off_match.group(1))

            v_parsed, fr_sym = self.parse_addr(x_off_match.group(1))

            if fr_sym is None:
                if v_parsed.addr < 256:
                    return (XOffsetZeroPageAddr(v_parsed.addr), None)
                else:
                    return (XOffsetAbsoluteValue(v_parsed.addr), None)
            else:
                return (None, fr_sym)
                #print("storing forward ref for line", x_off_match.group(1), line)
                #self.add_forward_ref(x_off_match.group(1), line)
                #return XOffsetAbsoluteValue(0)

        ind_pat = r"\((\S+)\)"

        ind_match = re.match(ind_pat, term)
        print("ind match:", ind_match)

        if ind_match:
            print("found indirect mode")

            print(" group 1: ", ind_match.group(1))
            v_parsed, fr_sym = self.parse_addr(ind_match.group(1))
            if fr_sym is None:
                return (IndirectAddr(v_parsed.addr), None)
            else:
                return (None, fr_sym)

        if term[0] == '#':
            # immediate val
            if term[1] == '$':
                # hex
                val_str = term[2:].strip()
                v = int(val_str, 16)
                if len(val_str) <= 2:
                    return (ImmediateByteValue(v), None)
                else:
                    return (ImmediateWordValue(v), None)
            else:
                assert(False)
        elif term[0] == '$':
            # addr
            addr = term[1:].strip()
            v = int(addr, 16)
            if len(addr) <= 2:
                return (ZeroPageAddr(v), None)
            else:
                return (AbsoluteAddr(v), None)
        else:
            print("can't parse term {}, assume it's a forward ref".format(term))
            return (None, term)



    def parse_args(self, line):
        #print("parsing args for line", line)
        while (len(line)> 0 and
               line[0].isspace()):
            line = line[1:]

        if not line:
            #print("no line")
            return (None, None)

        if line[0] == '"':
            return (parse_string(line), None)

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
            return (None, None)

    def tokenize_op(self, line):
        # return a pair (op, arg)
        # where op is a string representing the op or None
        # arg is an untokenized string, with no leading whitespace
        # can return None in case of empty line

        if not line:
            return None

        if line.strip() == '':
            return None

        delimiter_idx = -1

        for i in range(len(line)):
            if line[i].isspace():
                op = line[:i]
                return (op, line[i:].strip())

        # no delimiter, just return the op, no arg
        return (line, None)

    def trim_arg(self, arg):
        # input:
        #  arg might be None
        #  arg might have a comment
        #  arg might be a quoted string
        # output:
        #  None for an empty string
        #  comments removed
        #  leading and trailing whitespace removed

        if not arg:
            return None

        if arg.strip() == '':
            return None

        while arg and arg[0].isspace():
            arg = arg[1:]

        if arg[0] == ';':
            # all that remains is comment
            return None

        if arg[0] == '"':
            list_of_quote_indices = find_occurrances_of_char('"', arg)
            assert(len(list_of_quote_indices) >= 2)

            # TODO maybe return a wrapped argument type?
            trimmed_str = arg[1:list_of_quote_indices[1]]
            return trimmed_str

        if ';' in arg:
            semi_idx = arg.index(';')
            arg = arg[:semi_idx]

        return arg.strip()
        

    def parse_op_and_args(self, line):
        assert(len(line) > 0)
        delimiter_idx = -1

        for i in range(len(line)):
            if line[i].isspace():
                delimiter_idx = i
                break

        if delimiter_idx == -1:
            print("no delimiter found in", line)
            return line, (None, None)

        op = line[:delimiter_idx]
        args = self.parse_args(line[delimiter_idx:])
        print("found args:", args)
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

        print ("line starting with opcode:", line)

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
            label, op, arg_tuple = toks

            arg_addr, arg_fr_sym = arg_tuple

            if asm.do_pseudo_opcode(label, op, arg_addr):
                print("NO PSEUDO OPCODES IN MAKE_BYTES")
                assert(False)

            if not (arg_fr_sym is None):
                print("making bytes from forward ref?")
                assert(False)

            if arg_addr in asm.definitions:
                arg = asm.definitions[arg_addr]

            if type(arg_addr) == type("string"):
                print("CAN'T FIND LABEL {} WHEN FIXING FORWARD REF".format(op))
                assert(False)

            print("looking up op {} args {}".format(op, arg_addr, type(arg_addr)))
            inst_data = opcodes.lookup(op, arg_addr)

            inst_str = ""

            if inst_data:
                inst_str += hex(inst_data)[2:] + " "

                byte_list = [inst_data]
                if arg_addr:
                    for a in arg_addr.bytes():
                        inst_str += hex(a)[2:] + " "
                        byte_list.append(a)

                print("INST:", inst_str)

                return byte_list, inst_str

            elif arg_addr.mode == AddrMode.ABS:
                cur_addr = self.start_addr + byte_index - 2
                dest_addr = arg_addr.addr
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
                assert(False)


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
                return (ZeroPageAddr(s), None)
            else:
                return (AbsoluteAddr(s), None)
        elif arg[0]=='/':
            # high byte
            term = arg[1:]

            if term in self.definitions:
                v = self.definitions[term]
                return (ImmediateByteValue(v.addr >> 8), None)
            else:
                return (ImmediateByteValue(0), term)
        elif arg[0]=='#':
            # low byte
            term = arg[1:]

            if term in self.definitions:
                v = self.definitions[term]
                return (ImmediateByteValue(v.addr % 256), None)
            else:
                return (ImmediateByteValue(0), term)

        else:
            return None
                        
                        
    def tokenize_line(self, line):
        # returns a 3-ple: (label, op, arg)
        # label is a string or None
        # op is a string
        # arg is a string or none
        #
        # may return None for e.g. comment line

        if not line:
            return None

        if line.strip() == '':
            return None

        if line[0] == ';':
            # full-line comment, discard
            return None

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

        print ("line starting with opcode:", line)

        # should have an opcode at this point

        op_and_args = self.tokenize_op(line)

        if not op_and_args:
            raise ValueError()
        else:
            #print("op and args:", op_and_args)
            return label, op_and_args[0], op_and_args[1]

            

if __name__ == "__main__":
    assert(len(sys.argv) == 2)

    filename = sys.argv[1]

    asm = Assembler()

    jumps = ['JMP' , 'JSR']
    branches = ['BEQ', 'BNE', 'BCC', 'BCS',
                'BMI', 'BPL', 'BVC', 'BVS']
    

    with open(filename) as t:
        for line in t.readlines():
            tokens = asm.tokenize_line(line)

            print("found tokens",tokens)

            if tokens:
                label, op, arg = tokens

                arg = asm.trim_arg(arg)
                
                if asm.do_pseudo_opcode(label, op, arg):
                    print("processed pseudo opcode", label, op, arg)
                    continue

            
            toks = asm.parse_line(line)
            print("parsed tokens:", toks)

            if toks:
                label, op, arg_tuple = toks

                arg_addr, arg_fr_sym = arg_tuple

                if arg_addr in asm.definitions:
                    arg_addr = asm.definitions[arg_addr]

                if not (arg_fr_sym is None):
                    print("adding forward symbol", arg_fr_sym)
                    asm.add_forward_ref(arg_fr_sym, line)
                    arg_addr = AbsoluteAddr(0)

                    if op in jumps:
                        placeholder_arg = AbsoluteAddr(0)
                        inst_data = opcodes.lookup(op, placeholder_arg)
                    elif op in branches:
                        placeholder_arg = RelativeAddr(0)
                        inst_data = opcodes.lookup(op, placeholder_arg)
                    else:
                        # maybe this thing takes two bytes?
                        print("guessing arg {} is two bytes".format(arg_fr_sym))
                        placeholder_arg = AbsoluteAddr(0)
                        inst_data = opcodes.lookup(op, placeholder_arg)

                    arg_addr = placeholder_arg

                """
                if type(arg_addr) == type("string"):
                    math_res = asm.do_inline_math(arg_addr)

                    if math_res:
                        arg_addr = math_res
                    else:                    
                        print("UNDEFINED LABEL FOR", op)
                        if op in jumps:
                            placeholder_arg = AbsoluteAddr(0)
                            inst_data = opcodes.lookup(op, placeholder_arg)
                        elif op in branches:
                            placeholder_arg = RelativeAddr(0)
                            inst_data = opcodes.lookup(op, placeholder_arg)
                        else:
                            print("unexpected opcode", op)
                            assert(False)

                        #asm.add_forward_ref(arg, line)
                        arg_addr = placeholder_arg
                """

                print("looking up op {} arg {}".format(op, arg_addr))
                inst_data = opcodes.lookup(op, arg_addr)

                inst_str = ""
                if not (inst_data is None):
                    inst_str += hex(inst_data)[2:] + " "

                    byte_list = [inst_data]
                    if arg_addr:
                        for a in arg_addr.bytes():
                            inst_str += hex(a)[2:] + " "
                            byte_list.append(a)

                    print("INST:", inst_str)
                    if label:
                        asm.store_label(label)
                    asm.add_bytes(byte_list, inst_str)
                elif arg_addr.mode == AddrMode.ABS:
                    cur_addr = asm.next_addr + 2
                    dest_addr = arg_addr.addr
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
