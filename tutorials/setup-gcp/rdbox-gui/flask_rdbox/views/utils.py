#!/usr/bin/env python3
import psutil
import re
import os


class Utils(object):
    @classmethod
    def find_procs_by_name(cls, name):
        "Return a list of processes matching 'name'."
        assert name, name
        ls = []
        for p in psutil.process_iter():
            name_, exe, cmdline = "", "", []
            try:
                name_ = p.name()
                cmdline = p.cmdline()
                exe = p.exe()
            except (psutil.AccessDenied, psutil.ZombieProcess):
                pass
            except psutil.NoSuchProcess:
                continue
            if len(cmdline) > 1:
                if name == name_ or cmdline[0] == name or os.path.basename(exe) == name:
                    ls.append(name)
                if name in cmdline[1]:
                    ls.append(name)
        return ls

    @classmethod
    def format_properties(cls, properties):
        result = [k + ':' + re.sub(r'\;|\&|\(|\)|\$|\<|\>|\*|\?|\{|\}|\[|\]|\!|\"|\'', '', str(v)) for k, v in properties.items()]
        return ','.join(result)
