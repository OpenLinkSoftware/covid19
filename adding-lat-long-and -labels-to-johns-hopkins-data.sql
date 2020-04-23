-- DBpedia Country

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
   {  
        GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                {
                        ?s1 :dbpedia_country_id ?countryURI ;
                            schema:mainEntityOfPage ?bingCountryURL ;
                            skos:related ?divocCountryURL .

                        ?countryURI owl:sameAs ?bingCountryURI, ?divocCountryURI . 
                        ?bingCountryURI schema:url ?bingCountryURL .
                        ?divocCountryURI schema:url ?divocCountryURL . 
                }
   }
WHERE
    {
        GRAPH <urn:johns-hopkins:covid19:daily:reports>
          {  
                ?s1  <urn:johns-hopkins:covid19:daily:reports#Country_Region>  ?s4 . 
                BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')),'#')) as ?bingCountryURI)
                BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')))) as ?bingCountryURL)
                BIND (
                       IF( 
                           !CONTAINS(?s4,'US'),
                           IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(?s4),'&show=50&trendline=default&y=fixed&scale=log&data=cases#countries')), 
                           IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(bif:INITCAP(LCASE(?s4))),'&show=50&trendline=default&y=fixed&scale=log&data=cases#countries')) 
                        ) as ?divocCountryURI
                     )
                BIND (
                        IF( 
                            !CONTAINS(?s4,'US'),
                            IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(?s4),'&show=50&trendline=default&y=fixed&scale=log&data=cases')), 
                            IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(bif:INITCAP(LCASE(?s4))),'&show=50&trendline=default&y=fixed&scale=log&data=cases')) 
                        ) as ?divocCountryURL
                     )
          }
    }  ;


-- Bing and URI Minting for United States

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
        {  
                GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                        {
                                ?s1 :dbpedia_country_id ?countryURI .
                                
                                ?countryURI owl:sameAs <https://bing.com/covid/local/unitedstates#> . 
                                <https://bing.com/covid/local/unitedstates#>  schema:url <https://bing.com/covid/local/unitedstates>  .
                        }
        }
WHERE
        {
         GRAPH <urn:johns-hopkins:covid19:daily:reports>
                {  
                        ?s1  <urn:johns-hopkins:covid19:daily:reports#Country_Region>  ?s4 . 
                        BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                        FILTER (?s4 = "US"^^xsd:string)
                }
        }  ;

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

DELETE
        {  
                GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                        {
                                ?s1 :dbpedia_country_id ?countryURI .
                                
                                ?countryURI owl:sameAs <https://bing.com/covid/local/us#> . 
                                <https://bing.com/covid/local/us#>  schema:url <https://bing.com/covid/local/us>  .
                        }
        }
WHERE
        {
         GRAPH <urn:johns-hopkins:covid19:daily:reports>
                {  
                        ?s1  <urn:johns-hopkins:covid19:daily:reports#Country_Region>  ?s4 . 
                        BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                        FILTER (?s4 = "US"^^xsd:string)
                }
        }  ;



