#!/usr/bin/python3

from bcc import BPF
from time import sleep

program = """
int hello(void *ctx) {
  bpf_trace_printk("Hello world!\\n");
  return 0;
}
"""

b = BPF(text=program)
clone = b.get_syscall_fnname("clone")
b.attach_kprobe(event=clone, fn_name="hello")
b.trace_print();
