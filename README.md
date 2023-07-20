# Analysis and transformation of LIDO data

> Collect, analyze, validate and transform [LIDO](https://format.gbv.de/lido) from various sources

This repository contains resources for data integration of LIDO data sources as part of NFDI:
eventually an ETL process from LIDO (in different application profiles) to a knowledge graph
(with an RDF data model yet to be decided) and possibly the conversion from RDF to a JSON format.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
    - [Collect](#collect)
    - [Analyze](#analyze)
    - [Validate](#validate)
    - [Transform](#transform)
- [References](#references)
    - [Publications](#publications)
    - [Projects and applications](#projects-and-applications)

## Installation

Install required tools:

- [metha](https://github.com/miku/metha) OAI-PMH client
- `pigz` for faster decompression
- `xsltproc`, `xmllint` and `xmlstarlet` for XML processing
- `rapper` from `raptor-utils` for RDF processing

On Ubuntu you can run `sudo ./install.sh` to install these dependencies.

## Usage

### Collect

LIDO records are either harvested via OAI-PMH or manually put in form of files. 

*Don't commit actual LIDO records to this repository, except for unit tests!*

For instance it's possible to download allo LIDO records from kenom this way:

    metha-sync -format lido https://www.kenom.de/oai/

This will take a long while, so better set a `-from` date and/or a maximum number of requests, e.g.

    metha-sync -from 2023-06-01 -max 10 -format lido https://www.kenom.de/oai/

The records are stored in a cache directory that can be shown this way:

    metha-sync -dir -format lido https://www.kenom.de/oai/

You can then copy the harvested records into a single XML file:

    metha-cat -format lido https://www.kenom.de/oai/ > example.xml

Extract the LIDO records from their OAI-PMH envelope

    xsltproc oaiextract.xsl example.xml > example.lido.xml

Alternatively list all files to process sequentially

    find $(metha-sync -dir -format lido https://www.kenom.de/oai/) -name "*.gz" | xargs unpigz -c

### Analyze

#### Statistics and inspection
    
Count XML pathes

    xmlstarlet el example.lido.xml | sed s/^.*lido:lido\/// | sort |  uniq -c
    
#### Extract some XML elements

    xmlstarlet sel -N lido=http://www.lido-schema.org -t -c "//lido:descriptiveMetadata/lido:objectClassificationWrap" example.lido.xml 

### Validate

*TODO* (<https://github.com/gbv/lido-analysis/issues/2>)


### Transform

LIDO can be used as such but transformation to other formats and models makes sense for both data integration and analysis. Two basic forms of target structures exist:

- Flat data for simplified reuse and indexing in as search index (probably JSON)
- Graph data for knowlege graphs (probably RDF)
 
#### Convert to RDF

A minimal XSLT script to convert LIDO to RDF/XML is included

    xsltproc lido2rdf.xsl example.lido.xml > example.rdf

Better use another RDF serialization, at least NTriples:

    rapper -i rdfxml example.rdf > example.nt

Alternative: The conversion script to transform KENOM-LIDO to Numisma Data Model can be found at <https://github.com/AmericanNumismaticSociety/migration_scripts/blob/master/kenom/process-oai-pmh.php> (Apache License).


## References

### Related projects and applications

- The [LIDO Working Group](https://cidoc.mini.icom.museum/working-groups/lido/lido-community/) is working on a mapping of LIDO to RDF. Some general ideas can be found in [LIDO Primer](https://lido-schema.org/documents/primer/latest/lido-primer.html). See <https://gitlab.gwdg.de/lido> for sources and scripts
- Data from Kenom and SMB and is already being conerted into RDF at Nomisma.org (see download at <http://numismatics.org/rdf/kenom.rdf> and [conversion scripts](https://github.com/search?q=repo%3AAmericanNumismaticSociety%2Fmigration_scripts%20LIDO&type=code)).
- UB Leipzig has developed a [converter from LIDO to JSON](https://github.com/ubleipzig/lido-cli) for Solr/Finc/VuFind
- For Europeana LIDO is converted to Europeana Data Model (EDM)
- <https://www.cidoc-crm.org/mapping-tools> X3ML, supports LIDO to CRM but probably very shallow: <https://www.cidoc-crm.org/Resources/the-lido-model> 
- <http://kerameikos.org/> defines an ontology for pottery (there are connections to nomisma.org)
- ...

### Related Publications

- Regine Stein and Oguzhan Balandi (2019): Using LIDO for Evolving Object Documentation into CIDOC CRM. <https://doi.org/10.3390/heritage2010066> 
- Antje Niemann (2019): Ein Knowledge Graph für wissenschaftliche Sammlungen: Generierung von Linked Open Data für heterogene museale Sammlungen auf der Basis des ASCH-Modells. <https://doi.org/10.15771/MA_2019_1> 
- Eleni Tsalapati, Nikolaos Simou,Nasos Drosopoulos and Regine Stein (2012): Evolving LIDO based aggregations into Linked Data. <http://www.image.ntua.gr/php/pub_details.php?code=767>

