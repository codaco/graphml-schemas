# Purpose

This repository hosts the XML schema definition files for the Network Canvas extensions to GraphML. We needed to extend the GraphML format so that we could store Network Canvas meta data in the files, such as interview protocol, case ID, and session UUID.

A key aim of this process has been to ensure interoperability with existing GraphML parsers. If you encounter a compatibility issue, please file an issue against this repository!

## Schema extensions

Our extensions provide three namespaced attributes on the `<graphml>` element: `nc:caseID`, `nc:protocolUUID`, and `nc:sessionUUID`.

The schema `nc-types.xsd` defines these attributes, and `graphml+netcanvas.xsd` extends the element to include them.

## Ego data

Storing ego data is possible using the existing GraphML schema, although only in a general sense (artbitrary data can be attatched to the graph element). Existing parsers either ignore this data, or just show it (correctly) as one or more attributes of the graph itself. Our parsers will treat all graph `<key>` and `<data>` nodes as describing ego.

Specifically, ego data can be stored within GraphML just like we store node or edge data, except that instead of defining the element with a "for" attribute of either 'node' or 'edge', we can define them as for the graph:

``` XML
<key id="ego_attribute" attr.name="ego_attribute" attr.type="string" for="graph" />
```

**Note:** the key must be located outside of the `<graph>` element.

We can then give this attribute a value anywhere inside the `<graph>` element:

``` XML
<graph>
  <data key="ego_attribute">
    Jimbo
  </data>
</graph>
```

## Sample GraphML document

See the contents of `minimal.graphml`:

## Multiple networks in one file

The 'correct' way to approach this problem would be to have multiple `<graph>` nodes, with each representing an ego network. Node, Edge, and Ego attribute definitions would share `<key>`s, with the definitions within each graph. See the example in `minimal-multiple-networks.graphml` for an implementation of this.

Unfortunately, testing in Gephi, networkX, iGraph, visone, and yEd indicates that no currently available software correctly handles this feature of the graphML language. If you find one that does, please let us know.

Because of this, merged network export will be deferred for now. It can still be accomplished using the entity resolution mode of Server.

## Validating a file against this schema

To validate your graphML file against our extensions, please use the following command

``` bash
xmllint --noout --schema http://schema.networkcanvas.com/xmlns/1.0/graphml+netcanvas.xsd --load-trace  file.graphml
```

**Please note that `xmllint` does not support using HTTPS!**
