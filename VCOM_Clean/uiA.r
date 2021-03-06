#------------------------------------------------------------------------------#
################################################################################
## Malaria vector ODE model GUI                                               ##
## Hector M. Sanchez C. (sanchez.hmsc@itesm.mx)                               ##
## 02/May/2016                                                                ##
################################################################################
#------------------------------------------------------------------------------#

################################################################################
#LOAD LIBRARIES AND FILES
################################################################################
library(shiny)
library(deSolve)
library(ggplot2)
library(shinyjs)
library(shinythemes)
library(XLConnect)
library(plotly)
library(BH)
source("ODEModel.R")
source("ODEMosquitoParameters.R")
source("Parsers.R")
source("Plots.R")
source("ODEControlMeasuresParameters.R")
source("ODETransmissionParameters.R")
source("ODEInterventions.R")
source("ODEModelOutput.R")
source("ODEFeedingCycle.R")
################################################################################
DISALLOWED_HEADS<<-c("Life Cycle Parameters","Species-Specific Parameters","Interventions Parameters","Transmission Parameters","NA",paste0(rep("NA.",20),1:20))
importedFile=NULL
BOXES_WIDTH<<-"75px"
NAS_ALLOWED<<-11
ENTER_DOWN_RUN <<- '
  $(document).ready(function(){
    $("body").keydown(function(e){
      if(e.which === 13){$("#buttonRun").click();}
    });
  });'
WORKING_MESSAGE_STYLE <<- "#loadmessage {
    position: fixed;top: 50%;left: 0px;line-height: 80px;height: 100px;
    width: 100%;padding: 5px 0px 5px 0px;text-align: center;font-weight: bold;
    font-size: 200%;color: #FFFFFF;background-color: rgba(0, 0, 0, .5);z-index: 105;
  }"
# Theta from code----------------------------------
#initialTheta <<- getTheta()
# Theta from setup CSV-----------------------------
initialParametersValues<<-importCSVParametersFromDirectory("SetupTemplates/SETUP_MosquitoLifeCycleParameters.csv")
#print(initialParametersValues)
theta<<-parseImportedCSVParameters(initialParametersValues)
initState<<-calculateInitialState(theta)
IVM_traj<<-runODE(365,1,initState,theta,"lsoda")
#print(theta)
################################################################################
#TEMPLATE_AN_ARABIENSIS<<-importCSVParametersFromDirectory("SetupTemplates/Template_AnArabiensis.csv")
#TEMPLATE_AN_FUNESTUS<<-importCSVParametersFromDirectory("SetupTemplates/Template_AnFunestus.csv")
#TEMPLATE_AN_GAMBIAE<<-importCSVParametersFromDirectory("SetupTemplates/Template_AnGambiae.csv")
################################################################################
shinyUI(
  fluidPage(theme=shinytheme("cosmo"),
    useShinyjs(),
    #tags$script(ENTER_DOWN_RUN),
    tags$head(tags$style(type="text/css",WORKING_MESSAGE_STYLE)),
    conditionalPanel(condition="$('html').hasClass('shiny-busy')",tags$div("Working...",id="loadmessage")),
    titlePanel(h1("VCOM: Expert",align="center"),windowTitle="VCOM: Expert"),
    titlePanel(h4("Vector Control Optimization Model",align="center")),
    titlePanel(h4(tags$a(class="btn btn-danger", href="http://chipdelmal.github.io/VCOM/", "Home", style="display: block; width: 100%;"),align="center")),
    navbarPage("",id="nav",
      #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
      tabPanel("Main",
        sidebarLayout(
          sidebarPanel(
            titlePanel(h1("Instructions",align="left")),
            helpText("(1) Select the number of days for the simulation to run."),
            helpText("(2) Load the simulation setup file (CSV or XLS format). In case you currently do not have the template download it from the 'Downloads' tab."),
            helpText("    If the file was loaded correctly the model should have run automatically!"),
            helpText("(3) Download a PDF report of the plots or go to 'Files Output' to download individual plots in PNG format."),
            sliderInput("sliderTime","1. Days to Simulate:",min=1,max=365,value=365),
            fileInput('fileImport','2. Import CSV/XLS Parameters File',accept=c(
              'application/vnd.ms-excel',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              '.xls')
            ),
            tags$script('$("#fileImport").on("click",function(){this.value=null;});'),
            #fileInput('file1', 'Choose CSV/TXT File',accept=c('text/csv', 'text/comma-separated-values,text/plain')),
            #textOutput("importedMessage"),
            #actionButton("buttonRun","3. Run Model",width="100%"),
            #titlePanel(h1("Messages",align="left")),
            titlePanel(h1("")),
            textOutput("debugOutput"),
            fluidRow(h3("Download PDF")),
            downloadButton("downloadPlots", 'Download PDF Plots Report')
            #helpText("NOTE: For some reason shiny does not include a function to reset the upload file routine and does not upload a different version of
            #  the file if it is called the same way as the one that was uploaded previously. Currently working on a workaround but for now the solution
            #  is to refresh the page... it's driving me insane...
            #")
          ),
          mainPanel(
              plotlyOutput("plotEIR"),
              fluidRow(h1("")),
              fluidRow(h1("")),
              plotlyOutput("plotTrajectory"),
              fluidRow(h1("")),
              fluidRow(h1("")),
              plotlyOutput("plotDemographics"),
              fluidRow(h1("")),
              fluidRow(h1("")),
              #plotlyOutput("plotVC"),
              #plotlyOutput("plotR0"),
              plotlyOutput("plotHuman")
          )
        ),
        helpText("Contacts: <Model: Samson.Kiware@ucsf.edu, John.Marshall@berkeley.edu> <GUI: sanchez.hmsc@itesm.mx, tarrasch@berkeley.edu>"),
        helpText("Cite as: "),
        helpText("CSS theme downloaded from: http://bootswatch.com (MIT licence)")
      ),
      #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
      # tabPanel("Additional Output",
      #   mainPanel(
      #     #plotOutput("plotDemographics")
      #   )
      # ),
      tabPanel("Loaded Parameters",
        sidebarLayout(
          sidebarPanel(
            helpText("The table shows the parameters that are currently loaded into the model."),
            helpText("If there is no table shown the model should be running on the default parameters."),
            helpText("Go to 'Main/Import CSV/XLS Parameters File' to load your configuration."),
            helpText("If you do not have a configuration file go to 'Downloads/Download XLS Parameters Table'")
          ),
          mainPanel(
            tableOutput("fileContents")
          )
        )
      ),
      #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
      tabPanel("Downloads",
        sidebarLayout(
          sidebarPanel(
            helpText("You can download PNG files for the plots describing the behaviour of the simulated scenario.")#Please note that some of the buttons will only activate after the model has been run at least once and will be disabled if a file with an error was uploaded.")
          ),
          mainPanel(
            #titlePanel(h1("Templates",align="left")),
            fluidRow(
              column(5,align="center",
                titlePanel(h3("CSV/XLS Downloads",align="center")),
                titlePanel(h6("")),
                downloadButton("downloadTemplate", 'Download XLS Parameters Template'),
                #downloadButton("downloadParameters", 'Download Current CSV Parameters'),
                titlePanel(h6("")),
                downloadButton("downloadCSVTrace", 'Download CSV Trace')
              ),
              column(5,""),
              column(5,align="center",
                fluidRow(
                  titlePanel(h3("Plots",align="center")),
                  titlePanel(h6("")),
                  #radioButtons("radioFormat",label=h4("Plot Format"),choices=list("JPG"=".jpg","PNG"=".png"),selected="PNG"),
                  downloadButton("downloadPlotTrace", 'Download Trajectory Plot'),
                  h1(""),
                  downloadButton("downloadPlotEIR", 'Download EIR Plot'),
                  h1(""),
                  downloadButton("downloadPlotDemographics", 'Download Demographics Plot'),
                  h1(""),
                  downloadButton("downloadPlotVC", 'Download VC Plot'),
                  h1(""),
                  downloadButton("downloadPlotR0", 'Download R0 Plot'),
                  h1(""),
                  downloadButton("downloadPlotHuman", 'Download Human Plot'),
                  h1("")
                )
              )
            )
          )
        )
      )#,
      #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
#       tabPanel("Runtime Data",
#         titlePanel("Runtime data"),
#         tableOutput("IVM_Runtime")
#       )
      ###########################################################################
    )
  )
)
#################################################################################
