---
title: Codelist module
description: Tables for storing codelists
tags:
  - 3dcitydb
  - relational schema
---

## CODELIST and CODELIST_ENTRY tables

The CODELIST table is designed for registering code list used in the datasets, the ``CODELIST_TYPE`` column stores the qualified type of the code list (e.g. core:RelationTypeValue or bldg:BuildingClassValue). The URL column can be used for storing to an existing file in the Web containing the entire code list. The last column ``MIMETYPE`` allows to store the MIME type of the code list file (e.g. application/xml or application/json).

!!! info "NOTE"
Different code lists could be stored for the same ``CODELIST_TYPE`` (e.g. one for bldg:BuildingClassValue by the German cadastre and one from the Japanese government). In this case we would have two rows in the table with the same ``CODELIST_TYPE`` (in this example bldg:BuildingClassValue), but with different url values.

The ``CODELIST_ENTRY`` table is mainly used for storing all the code values of a code list. It is very useful, when the user wants to check if a code used in the PROPERTY table is really defined in the named code list. It is also very helpful, when the code list should also be exported together with the output dataset . In the ``CODELIST_ENTRY`` table, the ``CODELIST_ID`` is a foreign key referencing to the ``CODELIST`` table. The code value and its explanation are stored in the columns ``CODE`` and ``DEFINITION`` respectively.
