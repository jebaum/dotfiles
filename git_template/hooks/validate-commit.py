#!/usr/bin/python2

import sys, os
from subprocess import call

print(os.environ.get('EDITOR'))

if os.environ.get('EDITOR') != 'none':
  editor = os.environ['EDITOR']
else:
  editor = "vim"

message_file = sys.argv[1]

def check_format_rules(lineno, line):
    real_lineno = lineno + 1
    if lineno == 0:
        if len(line) > 50:
            return "Error %d: First line should be less than 50 characters " \
                    "in length." % (real_lineno,)
    if lineno == 1:
        if line:
            return "Error %d: Second line should be empty." % (real_lineno,)
    if not line.startswith('#'):
        if len(line) > 72:
            return "Error %d: No line should be over 72 characters long." % (
                    real_lineno,)
    return False


while True:
    commit_msg = list()
    errors = list()
    with open(message_file) as commit_fd:
        for lineno, line in enumerate(commit_fd):
            stripped_line = line.strip()
            commit_msg.append(line)
            e = check_format_rules(lineno, stripped_line)
            if e:
                errors.append(e)
    if errors:
        with open(message_file, 'w') as commit_fd:
            commit_fd.write('%s\n' % '# GIT COMMIT MESSAGE FORMAT ERRORS:')
            for error in errors:
                commit_fd.write('#    %s\n' % (error,))
            for line in commit_msg:
                commit_fd.write(line)
        re_edit = raw_input('Invalid git commit message format.  Press y to edit and n to cancel the commit. [y/n]')
        if re_edit.lower() in ('n','no'):
            sys.exit(1)
        call('%s %s' % (editor, message_file), shell=True)
        continue
    break
