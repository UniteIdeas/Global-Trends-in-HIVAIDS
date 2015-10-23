suppressPackageStartupMessages(library(googleVis))
library(shinydashboard)
library(shiny)
library(googleVis)
library(reshape2)
library(plyr)
library(scales)
library(ggplot2)

function(input, output) {   
                
                source("datamgt.R")

                #CHOOSE MEASURE
                setMeasures = as.vector(unique(MDGff$Series))
                setMeasures = setMeasures[order(setMeasures)]
                output$measureSelector = renderUI({
                        selectInput("measure", "Select a measure:", selected="AIDS deaths", choices = setMeasures)
                })

                #GIVEN THE SELECTED MEASURE, CHOOSE COUNTRY
                getRegions = reactive({
                        regionWData = MDGcount[MDGcount$Series == input$measure & MDGcount$Count>0, "Country"]
                        setRegions = as.vector(unique(regionWData))
                        setRegions = setRegions[order(setRegions)]     
                        setRegions
                })

                output$regionSelector = renderUI({
                        selectInput("region", "Choose from the countries with available data:", 
                                    selected="Afghanistan", choices = getRegions())
                })

                output$gvisPopn = renderGvis({
                        gvisGeoChart(MDGf[MDGf$SeriesCode %in% c(579) & MDGf$Year==2000,], locationvar="Country", colorvar="Population", 
                                     options=list(backgroundColor="lightblue", displayMode="Markers") )
                })
                
                output$gvisMotion = renderGvis({
                        gvisMotionChart(data=MDGfw, idvar="Country", timevar="Year", 
                                        xvar=names(MDGfw)[6], yvar=names(MDGfw)[7], colorvar="Region", 
                                        sizevar="Population", chartid="TrendsByCountry", 
                                        options=list(showXScalePicker=FALSE, showYScalePicker=FALSE))          
                })
                
                appDat <- reactive({
                        plotdata = MDGlong[MDGlong$Country==input$region & MDGlong$Series==input$measure,]
                        plotdata = plotdata[is.na(plotdata$Value)==FALSE,]
                        plotdata
                }) 
                
                output$trendplot = renderPlot( {
                        
                        if(nrow(appDat()) == 0) return() 
                        
                        subDat = appDat()
                        
                                if(grepl(pattern="[Pp]ercentage", input$measure)) 
                                        {
                                        subDat$Value = subDat$Value/100
                                        g = ggplot(subDat, aes(Year, Value)) + geom_point(aes(x=Year, y=Value, color="#F8766D"), size=5) +
                                                scale_y_continuous(labels=percent_format(), limits=c(0,1)) 
                                } else {
                                        g = ggplot(subDat, aes(Year, Value)) + geom_point(aes(x=Year, y=Value, color="#F8766D"), size=5) +
                                                scale_y_continuous(labels=comma)
                                }
                        
                        g = g + theme_trend + labs(x="Year", y="") + xlim(c(1990,2015))  + guides(color=FALSE)
 
                        print(g)

                }, height=400)  #end renderPlot
                
        } #server
