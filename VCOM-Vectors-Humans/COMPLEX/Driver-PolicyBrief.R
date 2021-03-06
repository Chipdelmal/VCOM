### This is the driver ###

# Source all the required files
# Run the model and generate outputs

## ##########################

# Clear all stored parameters:
rm(list=ls())

library(shiny)
library(deSolve)
library(ggplot2)
#library(gridGraphics)
#library(shinyjs)
#library(shinythemes)
source("ODEModel.R")
source("ODEMosquitoParameters.R")
source("ODEAuxiliaryFunctions.R")
source("ODEControlMeasuresParameters.R")
source("ODETransmissionParameters.R")
source("ODEInterventions.R")
#source("ODEInterventions - FirstPass.R")
source("ODEModelOutput.R")
source("FeedingCycle.R")
source("multiplot.R")
## Get parameter for a specific specie ######

##NOTE: Different start time for LAR and BIO will crush at the max time entered - to be fixed

# Run first for An. gambiae -
#MOSQUITO_PARAMETERS = getAnGambiaeParameters()
#MOSQUITO_PARAMETERS = getAnArabiensisParameters()
#MOSQUITO_PARAMETERS =  getAnFunestusParameters()

# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 100

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************
NumTools = 8
#FIX i

for (i in 1:NumTools){




  #Source reduction, coverage value, time it is on
  INITIAL_SRE_COVERAGE = 0.0
  INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #LArvaciding, coverage value, time it is on
  INITIAL_LAR_COVERAGE = .00
  INITIAL_LAR_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #Biological, coverage value, time it is on
  INITIAL_BIO_COVERAGE = .00
  INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #ATSB, coverage value, time it is on
  INITIAL_ATSB_COVERAGE = .00
  INITIAL_ATSB_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #Space Spraying, coverage value, time it is on
  INITIAL_SSP_COVERAGE = .00
  INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #Odor Traps, coverage value, time it is on
  INITIAL_OBT_COVERAGE = .00
  INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
  #LLINs, coverage value, time it is on

   INITIAL_ITN_COVERAGE = .00
    INITIAL_ITN_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

    #Cattle - Topical
    INITIAL_ECT_COVERAGE = 0.00
    INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

    INITIAL_HOU_COVERAGE = 0.0
    INITIAL_HOU_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

    INITIAL_OBT_COVERAGE = .00
    INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #IRS
  INITIAL_IRS_COVERAGE = 0.50
  INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
  #House modification
  INITIAL_HOU_COVERAGE = 0.0
  INITIAL_HOU_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #Personal Protection measure
  INITIAL_PPM_COVERAGE = 0.0
  INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
  #Cattle - Systemic
  INITIAL_ECS_COVERAGE = 0.00
  INITIAL_ECS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
  #Cattle - Topical
  #INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

  #Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
  INITIAL_OVI_COVERAGE = 0.00
  INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1



  if(i==2){
    INITIAL_ITN_COVERAGE = .80
    INITIAL_ITN_TIME     = 20
  }

  if(i==3){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20

    INITIAL_IRS_COVERAGE = 0.50
    INITIAL_IRS_TIME     = 20
  }
  if(i==4){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20

    INITIAL_LAR_COVERAGE = .50
    INITIAL_LAR_TIME     = 20
  }
  if(i==5){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20

    INITIAL_ECT_COVERAGE = 0.50
    INITIAL_ECT_TIME     = 20
  }
  if(i==6){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20
    #House modification
    INITIAL_HOU_COVERAGE = 0.50
    INITIAL_HOU_TIME     = 20
  }
  if(i==7){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20

    INITIAL_PPM_COVERAGE = 0.50
    INITIAL_PPM_TIME     = 20

  }
  if(i==8){
    INITIAL_ITN_COVERAGE = .50
    INITIAL_ITN_TIME     = 20

    INITIAL_ATSB_COVERAGE = 0.50
    INITIAL_ATSB_TIME     = 20

  }




## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
#INTERVENTION_PARAMETERS = getInterventionsParameters
  INTERVENTION_PARAMETERS = getInterventionsParameters(
                                  #Source Reduction
                          SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
                                #Larvaciding
                          LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
                                #Biological Control
                          BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,

                                  #ATSB
                          ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
                                #Space Spraying
                          SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
                                  #Odor Traps
                          OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
                                 #LLINs
                          ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
                                  #IRS
                          IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
                                  #House Modification
                          HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
                                  #Personal Protection Measure
                          PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
                                  #Cattle - Systemic
                          ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
                                 #Cattle - topical
                          ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
                                 #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
                          OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)


  theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS)
  #fix to incorporate specie
  #theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS,speciesSpecificParameters=getAnGambiaeParameters

 # browser()
## Initialize the model
  initState <<- calculateInitialState(theta)

  if (i==1){
## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
  IVM_traj_Control <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }

  if (i==2){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_80 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }

  if (i==3){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_IRS_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }
  if (i==4){

    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_LAR_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }

  if (i==5){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_ECT_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }

  if (i==6){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_HOU_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }
  if (i==7){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_PPM_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }
  if (i==8){
    ## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
    IVM_traj_LLIN_50_ATSB_50 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"lsoda")
  }

}

## SA Figues
#plot_SA_Figures(IVM_traj_Control,IVM_traj_LLIN_80,IVM_traj_LLIN_50,theta,INITIAL_MODELRUNTIME_VALUE)

plot_SA_Figures_v2(IVM_traj_Control,IVM_traj_LLIN_80,IVM_traj_LLIN_50_IRS_50,IVM_traj_LLIN_50_LAR_50,IVM_traj_LLIN_50_ECT_50,
                   IVM_traj_LLIN_50_HOU_50,IVM_traj_LLIN_50_PPM_50,IVM_traj_LLIN_50_ATSB_50,theta,INITIAL_MODELRUNTIME_VALUE)

#Additional
#Source reduction, coverage value, time it is on
# INITIAL_SRE_COVERAGE = 0.0
# INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #LArvaciding, coverage value, time it is on
# INITIAL_LAR_COVERAGE = .00
# INITIAL_LAR_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #Biological, coverage value, time it is on
# INITIAL_BIO_COVERAGE = .00
# INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #ATSB, coverage value, time it is on
# INITIAL_ATSB_COVERAGE = .00
# INITIAL_ATSB_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #Space Spraying, coverage value, time it is on
# INITIAL_SSP_COVERAGE = .00
# INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #Odor Traps, coverage value, time it is on
# INITIAL_OBT_COVERAGE = .10
# INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
# #LLINs, coverage value, time it is on
# INITIAL_ITN_COVERAGE = .60
# INITIAL_ITN_TIME     =  20
# #IRS
# INITIAL_IRS_COVERAGE = 0.50
# INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
# #House modification
# INITIAL_HOU_COVERAGE = 0.0
# INITIAL_HOU_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
# #Cattle - Systemic
# INITIAL_ECS_COVERAGE = 0.00
# INITIAL_ECS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
# #Cattle - Topical
# INITIAL_ECT_COVERAGE = 0.00
# INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#
# #Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
# INITIAL_OVI_COVERAGE = 0.00
# INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
