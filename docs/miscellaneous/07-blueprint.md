# Blueprint Specification

## Version 1.0

**Blueprint URL:** [https://mush.javanile.org/blueprint/](https://mush.javanile.org/blueprint/)
**Status:** Draft
**Author:** Community / Open Specification


## 1. Abstract

This document defines the **Blueprint System**, a formal convention for structuring plain text scripts using inline comment annotations.

The Blueprint System introduces:

* A **section-based organization model**
* A **machine-readable metadata layer**
* A **versioned specification mechanism**

Blueprints transform unstructured scripts into **semantically organized, parseable, and verifiable documents**, without breaking compatibility with existing interpreters (e.g., shell, Python, etc.).


## 2. Design Goals

The Blueprint System is designed to:

* Preserve **full backward compatibility** with existing scripting languages
* Enable **deterministic parsing** without executing code
* Support **static analysis and validation tools**
* Allow **extensibility via external specifications**
* Keep the system **simple and minimally opinionated**

 

## 3. Core Concepts

### 3.1 Blueprint

A **Blueprint** defines how a script is structured and interpreted.

Each script declares the Blueprint it follows via a dedicated bootstrap section.

All semantics are defined by the Blueprint referenced through `blueprint_url`.

 

### 3.2 Section

A **Section** is the fundamental unit of organization.

Each section consists of:

* A **header**
* A set of **attributes**
* An optional **body**

 

### 3.3 Attribute

Attributes are defined using inline comment annotations:

```
# @key: value
```

They provide structured metadata associated with a section.

 

## 4. Syntax

### 4.1 Attribute Format

```
# @<key>: <value>
```

Rules:

* MUST start with `# @`
* Key and value are separated by `:`
* Leading and trailing spaces are ignored

 

### 4.2 Section Header

A section begins with:

```
# @section_code: SCXXX
# @section_name: <name>
```

Rules:

* `section_code` MUST be unique within the file, **except for repeatable sections** (see §4.4)
* `section_name` defines the semantic role of the section


### 4.4 Repeatable Sections

Some section types MAY appear multiple times within the same file (e.g. one per appended source portion).

These are called **repeatable sections** and follow additional rules:

* They MUST include a `@source_index` attribute — a 1-based integer, unique within all instances of the same `section_code`
* Uniqueness is determined by the composite key `section_code + source_index`
* They MUST include a `@source_file` attribute identifying the origin file of the portion
* They MUST include a `@portion_type` attribute describing the role of the portion within the artifact

> **Note:** Only the final artifact is a *file*. Each appended chunk is a *portion*.

```
# @section_code: SC007
# @section_name: source
# @source_index: 1
# @source_file: src/utils.sh
# @portion_type: lib
```

Repeatable section codes are explicitly marked in the Standard Section Codes table (§8).

 

### 4.3 Section Body

All lines following the attributes, until the next `@section_code`, are considered the **section body**.

 

## 5. Bootstrap Section (Mandatory)

Every Blueprint-compliant file MUST start with a bootstrap section:

```
# @section_code: SC000
# @section_name: blueprint
# @blueprint_name: SSP
# @blueprint_version: 1.0
# @blueprint_url: https://mush.javanile.org/blueprint/
```

### Fields

| Key               | Description                         |
|   ----------- | ----------------------------------- |
| blueprint_name    | Name of the blueprint               |
| blueprint_version | Semantic version                    |
| blueprint_url     | Reference to the full specification |

---

## 6. Parsing Rules

A compliant parser MUST:

1. Read the file line by line
2. Detect a new section when encountering `@section_code`
3. Associate subsequent `@` attributes with the current section
4. Treat non-attribute lines as section body
5. Terminate a section when a new `@section_code` is found

Parsing MUST be deterministic and MUST NOT require code execution.

 

## 7. Attribute Naming

The Blueprint System does not enforce any namespacing convention for attributes.

Rules:

* Keys MUST use simple identifiers (e.g., `file_name`, `runtime_shell`)
* Keys MUST NOT use dot notation (e.g., `file.name`)
* Keys SHOULD be lowercase with underscores

All attribute semantics are defined exclusively by the Blueprint specification referenced in:

```
@blueprint_url
```

There is no implicit meaning associated with attribute names outside the declared Blueprint.

 

## 8. Standard Section Codes (Edition 1.0)

This specification defines the following standard section codes:

| Code  | Repeatable | Name       | Description                                      |
| ----- | ---------- | ---------- | ------------------------------------------------ |
| SC000 | no         | blueprint  | Bootstrap section (mandatory)                    |
| SC001 | no         | file-meta  | File metadata                                    |
| SC002 | no         | execution  | Main script logic                                |
| SC003 | no         | config     | Configuration data                               |
| SC004 | no         | doc        | Documentation                                    |
| SC005 | no         | functions  | Function declarations                            |
| SC006 | no         | entrypoint | Logical entrypoint (e.g. `main "$@"`)            |
| SC007 | **yes**    | source     | A portion appended from a source file (see §4.4) |

Additional section codes MAY be defined by custom Blueprints.

 

## 9. Example

```
# @section_code: SC000
# @section_name: blueprint
# @blueprint_name: SSP
# @blueprint_version: 1.0
# @blueprint_url: https://mush.javanile.org/blueprint/

# @section_code: SC001
# @section_name: file-meta
# @file_name: script.sh
# @file_type: sh

# @section_code: SC003
# @section_name: config

GREETING="Hello World"

# @section_code: SC005
# @section_name: functions

# @section_code: SC007
# @section_name: source
# @source_index: 1
# @source_file: src/lib/greet.sh
# @portion_type: lib

greet() {
  echo "${GREETING}"
}

# @section_code: SC007
# @section_name: source
# @source_index: 2
# @source_file: src/main.sh
# @portion_type: entrypoint

main() {
  greet
}

# @section_code: SC006
# @section_name: entrypoint

main "$@"
```

 

## 10. Validation

Blueprint-aware tools MAY:

* Validate required sections
* Enforce attribute presence
* Apply external schemas
* Detect structural inconsistencies

Validation MUST NOT require script execution.

 

## 11. Extensibility

The Blueprint System is open and extensible.

Anyone MAY:

* Define a custom Blueprint
* Extend section types
* Introduce new attributes
* Publish alternative specifications

Custom Blueprints MUST declare:

```
# @blueprint_name
# @blueprint_version
# @blueprint_url
```

 

## 12. Philosophy

The Blueprint System introduces a new layer:

**Structure without breaking execution**

It enables scripts to evolve from:

* plain text
  to
* structured artifacts
  to
* verifiable components

 

## 13. Future Work

Potential extensions include:

* Section dependencies
* Nested sections
* External schema validation
* Cross-file references

 

## 14. Conclusion

The Blueprint System provides a minimal yet powerful foundation for structuring scripts.

It is:

* Simple enough to adopt
* Powerful enough to scale
* Flexible enough to evolve

---

**End of Specification**
