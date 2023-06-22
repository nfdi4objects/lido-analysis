# Analysis and transformation of LIDO data

## Installation

Install required tools:

- [metha](https://github.com/miku/metha) OAI-PMH client
- `pigz` for faster decompression
- `xsltproc`, `xmllint` and `xmlstarlet` for XML processing
- `rapper` from `raptor-utils` for RDF processing

On Ubuntu you can run `sudo ./install.sh` to install these dependencies.

## Usage

### Harvest LIDO files

It's possible to download allo LIDO records from kenom this way:

    metha-sync -format lido https://www.kenom.de/oai/

This will take a long while, so better set a `-from` date and/or a maximum number of requests, e.g.

    metha-sync -from 2023-06-01 -max 10 -format lido https://www.kenom.de/oai/

The records are stored in a cache directory that can be shown this way:

    metha-sync -dir -format lido https://www.kenom.de/oai/

You can then copy the harvested records into a single XML file:

    metha-cat -format lido https://www.kenom.de/oai/ > example.xml

Alternatively list all files to process sequentially

    find $(metha-sync -dir -format lido https://www.kenom.de/oai/) -name "*.gz" | xargs unpigz -c

### Process LIDO files

Extract the LIDO records from their OAI-PMH envelope

    xsltproc oaiextract.xsl example.xml > example.lido.xml

#### Statistics
    
Count XML pathes

    xmlstarlet el example.lido.xml | sed s/^.*lido:lido\/// | sort |  uniq -c
    
#### Convert to RDF

A minimal XSLT script to convert LIDO to RDF/XML is included

    xsltproc lido2rdf.xsl example.lido.xml > example.rdf

Better use another RDF serialization, at least NTriples:

    rapper -i rdfxml example.rdf > example.nt

## References

### Publications

- Regine Stein and Oguzhan Balandi (2019): Using LIDO for Evolving Object Documentation into CIDOC CRM. <https://doi.org/10.3390/heritage2010066> 
- Antje Niemann (2019): Ein Knowledge Graph für wissenschaftliche Sammlungen : Generierung von Linked Open Data für heterogene museale Sammlungen auf der Basis des ASCH-Modells. <https://doi.org/10.15771/MA_2019_1> 
- Eleni Tsalapati, Nikolaos Simou,Nasos Drosopoulos and Regine Stein (2012): Evolving LIDO based aggregations into Linked Data. <http://www.image.ntua.gr/php/pub_details.php?code=767>

### Projects and tools

- Europeana converts LIDO to EDM
- <https://github.com/ubleipzig/lido-cli> LIDO to JSON for Solr
- <https://www.cidoc-crm.org/mapping-tools> X3ML, supports LIDO to CRM but probably very shallow: <https://www.cidoc-crm.org/Resources/the-lido-model> 
- ...
