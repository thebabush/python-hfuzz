#!/usr/bin/env python3

import struct

import hfuzz


hf = hfuzz.HFuzz()


def do_one(data):
    if len(data) < 8:
        return
    qword = struct.unpack('<Q', data[:8])[0]
    hf.trace_cmp8(qword, 0xDEADBEEF12345678)

hf.persistent(do_one)

