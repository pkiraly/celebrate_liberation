LIST of DATA SOURCES

MusicNet Codex
  CKAN: http://ckan.net/package/musicnet_codex
  NAME: musicnet_codex
  FORMAT: RDF
  
  SPARQL: http://api.kasabi.com/api/lookup-api-musicnet http://beta.kasabi.com/api/sparql-endpoint-musicnet
  ABOUT: http://musicnet.mspace.fm/blog/2011/01/19/musicnet-uri-scheme-and-linked-data-hosting/

Archives Hub Linked Data
  CKAN: http://ckan.net/package/archiveshub-linkeddata
  NAME: archiveshub-linkeddata
  FORMAT: N3
  
  SPARQL: http://data.archiveshub.ac.uk/sparql
  ABOUT: http://data.archiveshub.ac.uk
  
English Heritage Places
  This dataset contains metadata for about 400,000 nationally important places as recorded by English Heritage
  (http://www.english-heritage.org.uk/), the UK Government's statutory adviser on the historic environment.

  This dataset covers features located in England and is divided into various types:
    Listed Buildings -- buildings of special architectural or historic interest
    Scheduled Monuments -- nationally important sites and monuments from all periods of history
    Registered Parks & Gardens -- landscapes and naturally occuring features of national importance
    Historic Battlefields -- sites of important battles in English history
    Protected Wreck Sites -- sites of shipwrecks of national importance
  CKAN: http://ckan.net/package/englishheritage_places
  NAME: englishheritage_places
  
  API: http://beta.kasabi.com/api/search-api-english-heritage
  SPARQL: http://beta.kasabi.com/api/sparql-endpoint-english-heritage
  -
  EXAMPLE QUERY:
  select ?battle ?label ?long ?lat
  where {
    ?battle <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://data.kasabi.com/dataset/english-heritage/def/Battlefield>.
    ?battle <http://www.w3.org/2003/01/geo/wgs84_pos#long> ?long.
    ?battle <http://www.w3.org/2003/01/geo/wgs84_pos#lat> ?lat.
    ?battle <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?label
  }
  url: http://api.kasabi.com/api/historicbattlefieldlocations
  params:
  - apikey: [api key]
  - output: (grid|map)
  - limit: [number]
  EXAMPLE URL: http://api.kasabi.com/api/historicbattlefieldlocations?apikey=[api key]&limit=10&offset=10&output=grid
  
  curl --include -H "Accept: application/xml" "http://api.kasabi.com/api/historicbattlefieldlocations?apikey=[api key]&limit=10&offset=10&output=grid"
  
  curl --include -H "Accept: application/rdf+xml" "http://data.kasabi.com/dataset/english-heritage/battlefield/14"
HTTP/1.1 303 See Other
Access-Control-Allow-Headers: X-Requested-With, Content-Type
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Origin: *
Cache-Control: no-cache
Content-Type: text/html
Date: Wed, 13 Jul 2011 11:59:44 GMT
Location: http://data.kasabi.com/dataset/english-heritage/battlefield/14.rdf
Server: Apache/2.2.14 (Ubuntu)
Vary: Accept-Encoding
X-Powered-By: PHP/5.3.2-1ubuntu4.7
Content-Length: 0
Connection: keep-alive

Images from The National Archives on Flickr Commons http://ckan.net/package/tna_flickr_commons  tna_flickr_commons  - Flickr API    
Jerome: University of Lincoln Library data  http://ckan.net/package/jerome_lincoln  jerome_lincoln    http://jerome.library.lincoln.ac.uk/search/json   http://data.online.lincoln.ac.uk/documentation.html#bib
JISC Open Bibliography British National Bibliography dataset  http://ckan.net/package/jiscopenbib-bl_bnb-1  jiscopenbib-bl_bnb-1  RDF     http://openbiblio.net/2010/11/17/jisc-openbibliography-british-library-data-release/
Tyne and Wear Museums Collections (Imagine) http://ckan.net/package/twam_imagine  twam_imagine  RDF, N3     http://www.imagine.org.uk/
Cambridge University Library dataset #1 http://ckan.net/package/culds_1 culds_1 MARC, N3    http://data.lib.cam.ac.uk/endpoint.php?query=SELECT+*+WHERE+{%0D%0A++GRAPH+%3Chttp%3A%2F%2Fdata.lib.cam.ac.uk%2Fcontext%2Fdataset%2Fcambridge%2Fbib%3E+{+%3Fs+%3Fp+%3Fo+.+}%0D%0A}%0D%0ALIMIT+1000&output=htmltab&jsonp=&key=&show_inline=1 http://data.lib.cam.ac.uk/datasets.php
JISC MOSAIC Activity Data http://ckan.net/package/jisc_mosaic jisc_mosaic XML http://library.hud.ac.uk/mosaic/api.pl    http://www.daveyp.com/blog/archives/953
OpenURL Router Data (EDINA) http://ckan.net/package/openurl-router-data openurl-router-data CSV     http://openurl.ac.uk/doc/data/data.html

RUNNING the CODES
I.) bnb2solr.xsl
----------------
1) Purpose: index British National Bibliography with Apache Solr
2) Preparing: 
* download the BNB from ckan
* extract the XML files
* download Apache Solr 3.3
* extract it to a convenient place
* $ cd to path/to/apache solr
* $ cd examples
* $ java -jar start.jar
* download latest saxon9he XSLT processor from SourceForge (http://sourceforge.net/projects/saxon/files/Saxon-HE/9.3/)
* extract it to a convenient place

3) Run conversation from XML to JSON:
cd the/directory/where/BNB/files/exist
for file in BNBrdfdc[0-9][0-9].xml
do
java -Xms500M -Xmx3024M -jar /path/to/saxon9he.jar -t -s:$file -xsl:/path/to/celebrate_liberation/bnb2solr.xsl > $file.json
done

4) Run indexing with Solr:
for file in BNBrdfdc[0-9][0-9].xml.json
do
curl 'http://localhost:8983/solr/update/json?commit=true' --data-binary @$file -H 'Content-type:application/json'
done
