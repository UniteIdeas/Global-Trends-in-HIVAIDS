library(shinydashboard)

dashboardPage(
                dashboardHeader(title="United Nations 2015"),
                dashboardSidebar(
                        sidebarMenu(
                                menuItem("Global Trends", icon=icon("sliders"), tabName="motion"),
                                menuItem("Individual Country Trends", icon=icon("line-chart"), tabName="regionSelector"),
                                menuItem("About", icon=icon("pencil"), tabName="about")
                        )
                ),
                
                dashboardBody(
                        
                        tabItems(
                                
                                tabItem(tabName="motion", h3("Goal 6A:  Combat and begin to reverse the spread of HIV/AIDS"),  
                                        fluidRow(
                                                box(title="Global Trends", width="100%", status="primary", 
                                                    solidHeader=TRUE, collapsible=FALSE, htmlOutput("gvisMotion"))
                                        )
                                ),
                                
                                tabItem(tabName = "regionSelector", h2(""),               
                                        fluidRow(  
                                                box(title="", width=4, solidHeader=TRUE, status="warning", 
                                                    uiOutput("measureSelector"), uiOutput("regionSelector")), 
                                                box(title="Individual Country Trends", width=8, status="primary", 
                                                    solidHeader=TRUE, collapsible=FALSE, plotOutput("trendplot"))
                                        ) #fluidRow
                                ), #tabItem
                                
                                tabItem(tabName="dataAvail", h3("Number of Years with Data Available (1990-2015)"), 
                                        htmlOutput("gvisPopn")),
                                
                                tabItem(tabName="about", h3("Release Notes"), br(), 
                                        p("This app explores data related to the United Nations Millenium Development Goals 6A and 6B."),
                                        strong("  * 6A:  "), "Have halted by 2015 and begun to reverse the spread of HIV/AIDS", br(),
                                        strong("  * 6B:  "), "Achieve, by 2010, universal access to treatment for HIV/AIDS for all those who need it",
                                        br(), br(),
                                        
                                        p("Three data sets are combined to summarize annual reports of twelve MDG target measures as 
                                          well as population and health care expenses (% of GDP) for 234 countries and ten MDG regions.
                                          Note that the number of annual measurements for each MDG target varies greatly by country.  
                                          For example, only 81 countries reported at least 5 measurements of HIV incidence rate during 
                                          the period 1990-2015."),
                                        
                                        p("1.  Millenium Goals Indicator measures from 1990 through 2015 were obtained from 
                                          http://mdgs.un.org/unsd/mdg/Data.aspx.  Country regions were determined based on the official 
                                          MDG Regional Groupings list at 
                                          http://mdgs.un.org/unsd/mdg/Host.aspx?Content=Data/RegionalGroupings.htm."), 
                                        
                                        p("2.  Country populations from 1990 through 2015 are from the Population Division of the United Nations at 
                                          http://esa.un.org/unpd/wpp/DVD/."), 
                                        
                                        p("3.  Annual total health care expenditures from 2000 through 2013 are reported as a percent of gross domestic product (GDP).  
                                          These expenditures include both public and private costs and cover ",  
                                          em("the provision of health services, 
                                             family planning activities, nutrition activities, and emergency aid designated for health but
                                             does not include provision of water and sanitation."),  "Data are from The World Bank at
                                          http://data.worldbank.org/indicator/SH.XPD.TOTL.ZS."), 
                                        
                                        br(), 
                                        
                                        strong("Execution Instructions"), br(),
                                        p("In order for this application to run on your local system, the set of files 
                                          ui.R, server.R, and global.R will need to be available in your working directory 
                                          and the data sets MDG_Export_20150829nf.csv, WPP2015.csv, and WorldBank_healthexpGDP.csv 
                                          in a subdirectory named Data.")
        
                                )  #tabItem
   
                        ) )  #tabItems, dashboardBody

        ) #ui dashboardPage
                        
