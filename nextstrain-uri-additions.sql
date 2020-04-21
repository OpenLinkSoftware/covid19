LOG_ENABLE(2,1) ;

SPARQL
CLEAR GRAPH <urn:nextstrain:mappings> ;

SPARQL

PREFIX : <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#>

INSERT {  
         GRAPH <urn:nextstrain:mappings>
                { 
                        ?s1 schema:url ?strainURI ;
                            :dbpedia_country_id  ?countryURI .
                }
}
WHERE  {
        GRAPH <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv>
          {
            ?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#country> ?s3 .
            ?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#strain> ?strain.
            BIND(IRI(CONCAT('https://nextstrain.org/ncov/global?s=',REPLACE(?s3,' ','%20'),'/',?strain)) as ?strainURI) 
            BIND(IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s3,' ','_'))) as ?countryURI) 
          }
       } ;

-- Test 1

SPARQL

PREFIX : <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#>

SELECT distinct ?s1 ?strainURI ?countryURI
WHERE  {
        GRAPH <urn:nextstrain:mappings>
          {
            ?s1 :nextstrain_id  ?strainURI ;
                :dbpedia_country_id  ?countryURI .
            FILTER (?countryURI IN (<http://dbpedia.org/resource/Ghana>, <http://dbpedia.org/resource/Nigeria>))
          }
       } ;

-- Test 2

SPARQL

SELECT  xsd:date(?s9) as ?date_submitted 
        ?s11 as ?dbpedia_country_id 
        # ?s15 as ?nih_id  
        xsd:string(?s3) as ?gisaid_epi_id
        xsd:string(?s6) as ?submitting_lab
        xsd:string(?s8) as ?age
        xsd:string(?s12) as ?continent
        xsd:string(?s14) as ?host
        xsd:string(?s13) as ?sex
        xsd:string(?s10) as ?accession
        xsd:string(?s2) as ?strain
        ?s1 as ?id

# FROM <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv>
WHERE  
  { 
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#strain> ?s2} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#gisaid_epi_isl> ?s3} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#originating_lab> ?s4} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#length> ?s5} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#submitting_lab> ?s6} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#division_exposure> ?s7} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#age> ?s8} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#date_submitted> ?s9} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#genbank_accession> ?s10} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#dbpedia_country_id> ?s11} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#region> ?s12} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#sex> ?s13} .
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#host> ?s14} .  
    OPTIONAL {?s1 <https://github.com/nextstrain/ncov/raw/master/data/metadata.tsv#nih_id> ?s15} . 
    FILTER (?s11 IN (
                        <http://dbpedia.org/resource/Nigeria>, <http://dbpedia.org/resource/Ghana>, 
                        <http://dbpedia.org/resource/Senegal>
                    )
            )
  }
ORDER BY DESC 1 ;
