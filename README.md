# Final Project
**Authors:** [Lars Mehwald](https://github.com/LarsMehwald) and [Daniel Salgado Moreno](https://github.com/dsalgadom)

**Seminar:** [MPP-E1180: Introduction to Collaborative Social Science Data   Analysis](https://github.com/HertieDataScience/SyllabusAndLectures)

**Instructure:** [Christopher Gandrud](https://github.com/christophergandrud)

**Final Project** Collaborative Reaserch Project 

**IMPORTANT NOTE:** Work in Porgress. Please ask authors for permission before citing.  

## Task to perform
For the Collaborative Research Project you will pose an interesting social science question and attempt to answer it using standard academic practices including original data collection and statistical analysis. The project should be considered a ‘dry run’ for your thesis. The project has three presentation outputs designed to present your research to multiple audiences. The first is a oral presentation (10 minute maximum) given in the final class. The second is a standard academic paper (5,000 words maximum) that is fully reproducible and dynamically generated. The third is a website designed to present key aspects of your research in an engaging way to a general audience. The paper and website are due in the Final Exam Week. 

## File Structure: 

The main outputs of this research project are as follow: 

+ [Final Academic Paper](https://github.com/LarsMehwald/CSSR_FinalProject_Salgado_Mehwald/blob/master/Final_Project.pdf)
+ [Website](http://rpubs.com/LarsMehwald/133039)
+ [Presentation](http://larsmehwald.github.io/CSSR_FinalProject_Salgado_Mehwald)

All of which source their output from the MasterFile.R. This file in turn sources every other required file. 

Additionally, we have created a branch of this repository called gh-pages containing the website with our findings.

## Describing the repository - File Structure
    .
    ├──
    ├──Analysis                          # Folder containing all analysis files
    |  ├──DataAnalysis.R                 # Diferent Analysis performed in R File
    |  ├──DataMerging.R                  # Merging secuence necessary for DistrictData.csv construction in R file format
    |  ├──GeoCodesMaps.R                 # Construction of Maps based on Geo coding in R file format
    |  ├──data                           # Folder containing all .csv files saved after data cleaning in corresponding R files
    |  ├──RPackkages.R                   # Compilation of R packages 
    |  ├──SupportAnalysis                 # Further codes to be sourced by DataAnalysis.R
    |  | ├──RawData                       # Folder containing raw data files in .csv format before cleaning 
    ├──index.html                         # HTML file containing website
    ├──index.Rmd                         # R Markdown file creating website
    ├──Literature                        # Folder contaiing pdf files with all the literature used for this paper
    ├──MasterFile.R                      # Main sourcing file to run complete Data Analysis.
    ├──README.md                         # Readme File
    ├──References                        # Folder containing all bib files
    |  ├──Refereences.bib                # File containing all literatur references
    |  ├──RpackageCitations.bib          # File with all used packages for analysis
    |  ├──RpackageCitationsGeoMap.bib    # bib file containing used packages for Geo Referencing
    ├──Presentation.html                 # HTML file containing final output for in Class Presentation
    ├──Presentation.Rmd                  # Markdown file for Presentation output: HTML.file
    ├──ResearchProposal.pdf              # Pdf file containing final output for Research Proposal
    ├──ResearchProposal.Rmd              # Markdown file for Research proposal output: pdf_document
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

#### [Bundesverband Deutscher Stiftungen](http://www.stiftungen.org/uploads/tx_leonhardtdyncontent/downloads/BvDS_Stiftungsdichte_in_den_Landkreisen_2013_11.pdf)
Information on the total count of Foundations in the year 2013 was published by the BDS, prior to the fundations day "Tag der Stiftungen". We used the table published in this report. 

## Using 
R Core Team. 2015. [R: A Language and Environment for Statistical Computing](https://www.R-project.org/). Vienna, Austria: R Foundation for Statistical Computing . 


