CREATE PROCEDURE COVID19..JOHNS_HOPKINS_DAILY ()
{
LOG_ENABLE (2, 1); 

-- Geo coordinates

SPARQL
CLEAR GRAPH <urn:johns-hopkins:covid19:daily:reports:geo>   ;

SPARQL
PREFIX g: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX geo: <urn:johns-hopkins:covid19:daily:reports#>

INSERT { 
         GRAPH <urn:johns-hopkins:covid19:daily:reports:geo> 
                {
                  ?s g:lat ?lat ; 
                     g:long ?long 
                }
        } 
WHERE {
        ?s geo:Long_ ?long ; 
           geo:Lat ?lat . 
      } ;


-- Pref Label Cleanup
-- Countries and States

SPARQL
CLEAR GRAPH <urn:johns-hopkins:covid19:daily:reports:labels>  ;

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
        {  
                GRAPH <urn:johns-hopkins:covid19:daily:reports:labels> 
                        {
                        ?href skos:prefLabel ?prefLabel
                        }
        }
WHERE
        {
                SELECT ?s1 as ?href 
                        xsd:string(?s11) as ?name
                        ?image
                        xsd:dateTime(?s12) as ?date
                        CONCAT(?s13,' as of ',xsd:string(?s12)) as ?prefLabel
                        xsd:string(?s2) as ?fips
                        xsd:string(?s3) as ?state
                        xsd:string(?s4) as ?region
                        xsd:string(?s11) as ?admin


                FROM <urn:johns-hopkins:covid19:daily:reports>
                WHERE 
                        { 
                                # ?s1 <urn:johns-hopkins:covid19:daily:reports#FIPS> ?s2 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Province_State> ?s3 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Country_Region> ?s4 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Confirmed> ?s5 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Active> ?s6 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Deaths> ?s7 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Recovered> ?s8 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Lat> ?s9 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Long_> ?s10 . 
                                # ?s1 <urn:johns-hopkins:covid19:daily:reports#Admin2> ?s11 . 
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Last_Update> ?s12 .  
                                ?s1 <urn:johns-hopkins:covid19:daily:reports#Combined_Key> ?s13 .  
                        }
        }  ;

-- Labeling for Countries 

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
{  
        GRAPH <urn:johns-hopkins:covid19:daily:reports:labels> 
                {
                  ?href skos:prefLabel ?prefLabel
                }
}
WHERE
{
        SELECT ?s1 as ?href 
                xsd:string(?s11) as ?name
                ?image
                xsd:dateTime(?s12) as ?date
                CONCAT(?s13,' as of ',xsd:string(?s12)) as ?prefLabel
                xsd:string(?s2) as ?fips
                xsd:string(?s3) as ?state
                xsd:string(?s4) as ?region
                xsd:string(?s11) as ?admin
        FROM <urn:johns-hopkins:covid19:daily:reports>
        WHERE 
        { 
                 # ?s1 <urn:johns-hopkins:covid19:daily:reports#FIPS> ?s2 . 
                 # ?s1 <urn:johns-hopkins:covid19:daily:reports#Province_State> ?s3 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Country_Region> ?s4 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Confirmed> ?s5 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Active> ?s6 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Deaths> ?s7 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Recovered> ?s8 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Lat> ?s9 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Long_> ?s10 . 
                 # ?s1 <urn:johns-hopkins:covid19:daily:reports#Admin2> ?s11 . 
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Last_Update> ?s12 .  
                 ?s1 <urn:johns-hopkins:covid19:daily:reports#Combined_Key> ?s13 .  
        }
}  ;

-- DBpedia State, County, FIPS Mapping

SPARQL
CLEAR GRAPH <urn:dbpedia:country:state:country:fips:mapping>   ;

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
        {  
                GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                        {
                        ?s1 :dbpedia_county_id ?countyURI .
                        }
        }
WHERE {
          GRAPH <urn:johns-hopkins:covid19:daily:reports>   
             {   
                ?s1 <urn:johns-hopkins:covid19:daily:reports#FIPS> ?s2 . 
                ?s1 <urn:johns-hopkins:covid19:daily:reports#Province_State> ?s3 . 
                ?s1 <urn:johns-hopkins:covid19:daily:reports#Admin2> ?s11 . 
                BIND (IRI(CONCAT('http://dbpedia.org/resource/',?s11,'_County,','_',REPLACE(?s3," ","_"))) as ?countyURI) . 
             }

      }  ;

-- DBpedia Country, State

SPARQL

PREFIX : <urn:johns-hopkins:covid19:daily:reports#> 

INSERT 
        {  
                GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                        {
                        ?s1 :dbpedia_state_id ?stateURI ;
                        :dbpedia_country_id ?countryURI .
                        }
        }
WHERE
        {
        GRAPH <urn:johns-hopkins:covid19:daily:reports>
                {  
                        ?s1 <urn:johns-hopkins:covid19:daily:reports#Province_State> ?s3 . 
                        ?s1 <urn:johns-hopkins:covid19:daily:reports#Country_Region> ?s4 . 
                        BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s3," ","_"))) as ?stateURI) .
                        BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                }
        }  ;


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
                # BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')),'#')) as ?bingCountryURI)
                # BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')))) as ?bingCountryURL)
                BIND (
                        IF ( 
                                !CONTAINS(?country,'US'),
                                IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')),'#')), 
                                IRI('https://bing.com/covid/local/unitedstates#') 
                            ) 
                        AS ?bingCountryURI
                     )
                BIND (
                        IF ( 
                                !CONTAINS(?country,'US'),
                                IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,' ','')),'#')), 
                                IRI('https://bing.com/covid/local/unitedstates') 
                           ) 
                        AS ?bingCountryURL
                     )
                BIND (
                       IF( 
                           !CONTAINS(?s4,'US'),
                           IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(?s4),'&show=50&trendline=default&y=fixed&scale=log&data=cases#countries')), 
                           IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(bif:INITCAP(LCASE(?s4))),'&show=50&trendline=default&y=fixed&scale=log&data=cases#countries')) 
                        ) AS ?divocCountryURI
                     )
                BIND (
                        IF( 
                            !CONTAINS(?s4,'US'),
                            IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(?s4),'&show=50&trendline=default&y=fixed&scale=log&data=cases')), 
                            IRI(CONCAT('https://91-divoc.com/pages/covid-visualization/?chart=countries&highlight=',encode_for_uri(bif:INITCAP(LCASE(?s4))),'&show=50&trendline=default&y=fixed&scale=log&data=cases')) 
                        ) AS ?divocCountryURL
                     )
          }
    }  ;




RETURN 1 ;

}
