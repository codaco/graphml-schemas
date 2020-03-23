# Purpose

This repository hosts the XML schema definition files for the Network Canvas extensions to GraphML. We needed to extend the GraphML format so that we could store Network Canvas meta data in the files, such as interview protocol, case ID, and session UUID.

A key aim of this process has been to ensure interoperability with existing GraphML parsers. If you encounter a compatibility issue, please file an issue against this repository!

## Schema extensions

Our extensions provide three namespaced attributes on the `<graphml>` element: `nc:caseID`, `nc:protocolUUID`, and `nc:sessionUUID`.

The schema `nc-types.xsd` defines these attributes, and `graphml+netcanvas.xsd` extends the element to include them.

## Ego data

Storing ego data is possible using the existing GraphML schema, although only in a general sense (artbitrary data can be attatched to the graph element). Existing parsers either ignore this data, or just show it correct as one or more child attributes of the graph element. Our parsers will treat all graph `<key>` and `<data>` nodes as describing ego.

Specifically, ego data can be stored within GraphML just like we store node or edge data, except that instead of defining the element with a "for" attribute of either 'node' or 'edge', we can define them as for the graph:

``` XML
<key id="ego_attribute" attr.name="ego_attribute" attr.type="string" for="graph" />
```

We can then give this attribute a value anywhere inside the <graph> element:

``` XML
<graph>
  <data key="ego_attribute">
    Jimbo
  </data>
</graph>
```

## Sample GraphML document

See the contents of `minimal.graphml`:

``` XML
<?xml version="1.0" encoding="UTF-8"?>
<graphml 
    xmlns="http://graphml.graphdrawing.org/xmlns"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://schema.networkcanvas.com/xmlns http://schema.networkcanvas.com/xmlns/1.0/graphml+netcanvas.xsd"
    xmlns:nc="http://schema.networkcanvas.com/xmlns"
    nc:caseID="12345"
    nc:sessionUUID="9170f62f-4d06-4af9-8120-8dd7836e37f8"
    nc:protocolUUID="9170f62f-4d06-4af9-8120-8dd7836e37f7"
>
    <graph edgedefault="directed">
        <key id="ego_name" attr.name="ego_name" attr.type="string" for="graph" />
        <data key="ego_name">Jimbo</data>
        <node id="n0"/>
        <node id="n1" />
        <edge source="n0" target="n1"/>
    </graph>
</graphml>
```

## Validating a file against this schema

To validate your graphML file against our extensions, please use the following command

``` bash
xmllint --noout --schema http://schema.networkcanvas.com/xmlns/1.0/graphml+netcanvas.xsd --load-trace  file.graphml
```

**Please note that `xmllint` does not support using HTTPS!**
