#!/bin/bash
# Example: changing file permissions in Linux

touch sample.txt
ls -l sample.txt

chmod 744 sample.txt
echo "Changed permissions to rwxr--r--"
ls -l sample.txt
