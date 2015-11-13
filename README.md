# Third Pair Assignment
**Authors:** [Lars Mehwald](https://github.com/LarsMehwald) and [Daniel Salgado Moreno](https://github.com/dsalgadom)

**Seminar:** [MPP-E1180: Introduction to Collaborative Social Science Data   Analysis](https://github.com/HertieDataScience/SyllabusAndLectures)

**Instructure:** [Christopher Gandrud](https://github.com/christophergandrud)

**Task 3:** Data collection and statistical analyses 

**IMPORTANT NOTE:** Work in Porgress. Please ask authors for permission before citing   

## Task to perform
In the third pair assignment you will *gather web based data* from at least two sources, *merge the data sets*, conduct *basic descriptive and inferential statistics* on the data to *address a relevant research question* and briefly *describe the results* including with dynamically generated tables and figures.  
Students are encouraged to access data and perform statistical analyses with an eye to *answering questions relevant for their Collaborative Research Project*. Deadline 13 November, the write up should be 1,500 words maximum and use literate programming, 10% of final grade.

## Describing the repository - File Structure
    .
    ├──
    ├──Analysis                          # Folder containing all analysis files
    |  ├──DataAnalysis.R                 # Diferent Analysis performed in R File
    |  ├──DataMerging.R                  # Merging secuence necessary for DistrictData.csv construction in R file format
    |  ├──GeoCodesMaps.R                 # Construction of Maps based on Geo coding in R file format
    |  ├──data                           # Folder containing all .csv files saved after data cleaning in corresponding R files
    | | ├──RawData                       # Folder containing raw data files in .csv format before cleaning 
    ├──Literature                        # Folder contaiing pdf files with all the literature used for this paper
    ├──README.md                         # Readme File
    ├──References                        # Folder containing all bib files
    |  ├──Refereences.bib                # File containing all literatur references
    |  ├──RpackageCitations.bib          # File with all used packages for analysis
    |  ├──RpackageCitationsGeoMap.bib    # bib file containing used packages for Geo Referencing
    ├──ResearchProposal.Rmd              # Markdown file for Research proposal output: pdf_document
    ├──Regression_plot_cache             #
    ├──Supplementary                     # Folder containing pdf files with additional literature for R coding and Quantitative Criminology. 

## Data used 
#### [Bundeskriminalamt](http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2014/BKATabellen/FaelleLaenderKreiseStaedte/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleKreiseFallentwicklung__csv.csv): 
Grundtabelle - Kreise - Fallentwicklung - ausgewählte Straftaten/-gruppen (2013)

#### [Open Data Germany](https://www.govdata.de)  

Data licence Germany – attribution – [Version 2.0](see: https://www.govdata.de/dl-de/by-2-0)

#### [Regional Database Germany editor](https://www.regionalstatistik.de/genesis/online)
Regional Database Germany is published by the Federal Statistical Office and the statistical Offices of the Länder,
represented by the Presidents
Federal Statistical Office and the statistical Offices of the Länder
Mauerstraße 51
D-40476 Düsseldorf   

#### [Statistical offices of the Federation and the Länder](http://www.statistikportal.de/Statistik-Portal/en/)

The legally defined functions of official statistics in the Federal Republic of Germany are performed by the statistical offices of the 16 Länder and the Federal Statistical Office, following the federal principle in accordance with the state and administrative structure. The results are published through largely coordinated publication programmes and through specific websites.

In order to even better meet the interests and information needs of the customers and users of statistical data, this common statistics portal has been implemented in addition. Its purpose is to provide central access to basic statistical information and to facilitate comparison between such information across Länder.


## Using 
R Core Team. 2015. [R: A Language and Environment for Statistical Computing](https://www.R-project.org/). Vienna, Austria: R Foundation for Statistical Computing . 


