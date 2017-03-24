#!/usr/bin/env python3
# Python implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>

import argparse
import os
import re


class Definition:

    RE_VAR_STR = "([a-zA-Z_][a-zA-Z0-9_]*)"
    RE_STR_STR = "(?:(?:\"([^\"]*)\")|{var_regex})".format(var_regex=RE_VAR_STR)

    RE_GS_STR = "\\s*{re_var_str}\\s*=\\s*{{".format(re_var_str=RE_VAR_STR)
    RE_ASS_STR = "\\s*{re_var_str}\\s*=\\s*{re_str_str}\\s*;".format(re_var_str=RE_VAR_STR, re_str_str=RE_STR_STR)
    RE_GE_STR = "\\s*}}\\s*;".format()

    RE_GS = re.compile(RE_GS_STR)
    RE_ASS = re.compile(RE_ASS_STR)
    RE_GE = re.compile(RE_GE_STR)

    def __init__(self, filename):
        self._data = {}
        self._template = None
        self.read_file(filename=filename)

    def get_template(self):
        return self._template

    def get_data(self):
        return self._data

    def read_file(self, filename):
        file = open(filename, "r")
        self._template = self.find_template(file=file)
        if not self._template:
            raise ValueError("Template file not found")

        pos = 0
        contents = file.read()

        while True:
                pos, group_name, assignments = self.match_group(contents, pos)
                if pos is None:
                    break
                if group_name not in self._data:
                    self._data[group_name] = [assignments]
                else:
                    self._data[group_name].append(assignments)

    @staticmethod
    def find_template(file):
        re_temp = re.compile("autogen definitions ([A-Z\._-]+);", re.IGNORECASE)
        while True:
            line = file.readline()
            if not line:
                return None
            line = line.strip()
            match = re_temp.match(line)
            if match:
                template  = match.group(1)
                return template

    @classmethod
    def match_group(cls, content, pos):
        match_gs = cls.RE_GS.match(content, pos=pos)
        if not match_gs:
            return None, None, None
        group_name = match_gs.group(1)
        pos = match_gs.span()[1]
        assignments = {}
        while True:
            assignment = cls.RE_ASS.match(content, pos=pos)
            if not assignment:
                break
            key = assignment.group(1)
            value = assignment.group(2) or assignment.group(3)
            pos = assignment.span()[1]
            assignments[key] = value
        match_ge = cls.RE_GE.match(content, pos=pos)
        if not match_ge:
            raise ValueError("Group end not matched.")
            return None, None, None
        pos = match_ge.span()[1]
        return pos, group_name, assignments

    RE_GROUP_TMPL = re.compile("\\[\\+\\s+([a-zA-Z0-9_\\(\\)\\\") ]+)\\s+\\+\\]")
    RE_GET_TMPL = re.compile("\\(get {re_str_str}\\)".format(re_str_str=RE_STR_STR))

    def parse_template(self):
        f = open(self.get_template(), "r")

        contents = f.read()
        stack = []
        lastpos = 0

        header_match = self.RE_GROUP_TMPL.search(contents, pos=lastpos)
        if not header_match:
            raise ValueError("Is not a template")

        extension_match = re.match("AutoGen[0-9]+ template ([a-zA-Z][a-zA-Z0-9]*)", header_match.group(1), re.I)
        if not extension_match:
            raise ValueError("Could not determine extension of output file")
        extension = extension_match.group(1)
        base, _ = os.path.splitext(self.get_template())
        out_filename = base + "." + extension
        out = open(out_filename, "w")

        out.write(contents[:header_match.span()[0]])
        lastpos = header_match.span()[1]

        while True:
            group_tmpl_match = self.RE_GROUP_TMPL.search(contents, pos=lastpos)
            if not group_tmpl_match:
                if stack:
                    raise ValueError('Stack not empty at end of file')
                out.write(contents[lastpos:])
                break

            out.write(contents[lastpos:group_tmpl_match.span()[0]])
            lastpos = group_tmpl_match.span()[1]

            group_tmpl_content = group_tmpl_match.group(1)
            if group_tmpl_content.startswith("FOR"):
                key = group_tmpl_content.split(' ')[1]
                stack.append([key, 0, lastpos])
            elif group_tmpl_content.startswith("ENDFOR"):
                if not stack:
                    raise ValueError("ENDFOR: stack was empty")
                [stackfor, stackindex, stacklastpos] = stack.pop()
                endkey = group_tmpl_content.split(' ')[1]
                if stackfor != endkey:
                    raise ValueError("FOR and ENDFOR do not match. FOR: {stackfor}, ENDFOR:{endkey}".format(
                        forkey=stackfor, endkey=endkey))
                data = self.get_data()[stackfor]
                stackindex += 1
                if stackindex != len(data):
                    stack.append([stackfor, stackindex, stacklastpos])
                    lastpos = stacklastpos
            else:
                get_match = self.RE_GET_TMPL.match(group_tmpl_content)
                if not get_match:
                    raise ValueError("Unknown construct")

                all_keys = dict()
                for s in stack:
                    [stackfor, stackindex, _] = s
                    all_keys.update(d.get_data()[stackfor][stackindex])
                get = get_match.group(1) or get_match.group(2)
                out.write(all_keys[get])


d = Definition(filename="floating_point_test.def")

d.parse_template()
