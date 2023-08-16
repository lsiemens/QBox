#!/usr/bin/env python3

"""
Take documentation markdown files from the QBox repository and make
compatible with jekyll.
"""

import os
import re

root_path = "README.md"

class page:
    def __init__(self, path, title=""):
        self.path = path
        self.links = []
        self.title = title

        self.readPage()

    def readPage(self):
        text = ""
        with open(self.path, "r") as fin:
            text = fin.read()

        regex = re.compile("\(.*?\.md\)")
        matches = re.findall(regex, text)
        links = [page(file[1:-1]) for file in matches]
        self.links = links

    def getPagePaths(self):
        paths = [self.path] + [item for link in self.links for item in link.getPagePaths()]
        return paths

    def addHeader(self):
        for link in self.links:
            link.addHeader()

        text = ""
        title = ""
        with open(self.path, "r") as fin:
            text = fin.read()

        text = [line for line in text.split("\n")]
        if self.title == "":
            title, text = text[0], text[1:]
            if "#" in title:
                title = title.replace("#", "").strip()
            else:
                raise RuntimeError(f"No Title in first line of .md file \"{self.path}\"")
        else:
            title, text = self.title, text[1:]
        header = f"---\nlayout: page\ntitle: \"{title}\"\ndate: 2020-01-01\n---\n"

        file = header + "\n".join(text)

        with open(self.path, "w") as fout:
            fout.write(file)

root = page(root_path, "Documentation")
documentation = root.getPagePaths()

for file in os.listdir("./"):
    if (file not in documentation) and (".md" in file):
       os.remove(file)

root.addHeader()
