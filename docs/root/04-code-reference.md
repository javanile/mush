---
layout: default
title: Code Reference
permalink: /reference/
nav_order: 04
has_children: true
has_toc: false
---

# Code Reference

Mush is a versatile and extensible tool that serves as a wrapper for shell scripting languages, 
designed to facilitate the organization and construction of codebases. 
While Mush allows for the use of any shell script practices, it provides specific keywords 
for loading files and linking the final artifact, which will be built. 
Mush is also extendable through plugins, allowing customization of language rules and build processes.

## File Organization

Mush scripts (.sh files) are free from specific constraints, 
allowing the use of typical shell scripting practices. 
However, for better codebase organization, Mush encourages the use of Mush-specific keywords 
for loading files and linking the final artifact.

## Keywords

The following keywords are reserved for Mush-specific use:

* [module](/reference/module)
* [public](/reference/public)
* [extern package](/reference/extern-package)
* [use](/reference/use)
* [embed](/reference/embed)
* [legacy](/reference/legacy)

## Extensibility with Plugins

Mush can be extended by writing plugins, enabling you to customize language rules and build processes to meet specific project requirements.
For more information on writing plugins and extending Mush, please refer to the Mush documentation.

## Conclusion

Mush provides a set of keywords to help organize codebases and manage dependencies efficiently. 
It combines the flexibility of shell scripting with the benefits of a modular, 
extensible approach to code organization and building.
