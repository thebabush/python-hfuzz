#!/usr/bin/env python3

import struct
import sys

import hfuzz


hf = hfuzz.HFuzz()


with open(sys.argv[1], 'rb') as f:
    hf.trace_cmp8(struct.unpack('<Q', f.read(8))[0], 0xDEADBEEF12345678)

