
#EDIT THIS TO POINT TO DIRECTORY WITH YOUR DATAFILE
#MDG data downloaded from http://mdgs.un.org/unsd/mdg/Data.aspx
MDGdat <- read.csv("Data/MDG_Export_20150829nf.csv", stringsAsFactors=FALSE)

#INDICATORS IN MDG DATABASE (SeriesCode value in parentheses)
#AIDS deaths (579)
#AIDS orphans (622)
#Condom use to overall contraceptive use among currently married women (733)
#Condom use at last high-risk sex, 15-24 years old, men (734)
#Condom use at last high-risk sex, 15-24 years old, women (735)
#Men 15-24 with comprehensive correct knowledge of HIV/AIDS (741)
#Women 15-14 with comprehensive correct knowledge of HIV/AIDS (742)
#HIV prevalence rate, men 15-49 years old (747)
#HIV prevalence rate, women 15-49 years old (748)
#Antiretroviral therapy coverage among people with advanced HIV infection (765)
#HIV incidence rate, 15-49 years old (801)
#Percentage of HIV-infected women who received antiretroviral drugs to reduce transmission risk (806)


#subset data to include only relevant variables
MDGsub = MDGdat[MDGdat$SeriesCode %in% 
                c(579, 622, 733, 734, 735, 741, 742, 747, 748, 765, 801, 806),]

#Keep cols with X1990, X1991, ... 
years = paste("X", seq(1990, 2015), sep="")
MDGwide = MDGsub[,c("CountryCode", "Country", "SeriesCode","MDG", "Series", years)]
names(MDGwide)[6:31] = gsub("X", "", names(MDGwide)[6:31])
MDGwide$Obs = rownames(MDGwide)


#Reshape data wide to long
MDGlong = reshape(MDGwide, varying=c(6:31), direction="long", idvar="Obs",
                  times=1990:2015, timevar="Year", v.name="Value")
MDGlong$Gender = "All"
MDGlong$Gender[MDGlong$SeriesCode %in% c(747, 734, 741)] = "Male"
MDGlong$Gender[MDGlong$SeriesCode %in% c(748, 735, 742)] = "Female"

#Map countries into regions code (from http://mdgs.un.org/unsd/mdg/Host.aspx?Content=Data/RegionalGroupings.htm)
MDGlong$Region[MDGlong$Country %in% c("Albania", "Andorra", "Australia", "Austria", 
        "Belarus", "Belgium", "Bermuda", "Bosnia and Herzegovina", "Bulgaria", "Canada",
        "Channel Islands", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", 
        "Faeroe Islands", "Finland", "France", "Germany", "Greece", "Greenland", "Hungary",
        "Iceland", "Ireland", "Isle of Man", "Israel", "Italy", "Japan", "Latvia", 
        "Liechetenstein", "Lithuania", "Luxembourg", "Malta", "Monaco", "Montenegro", 
        "Netherlands", "New Zealand", "Norway", "Poland", "Portugal", "Republic of Moldova", 
        "Romania", "Russian Federation", "San Marino", "Serbia", "Slovakia", "Slovenia",
        "Spain", "Sweden", "Switzerland", "TFYR of Macedonia", "Ukraine", "United Kingdom",
        "United States")] = "Developed"
MDGlong$Region[grepl("Czechoslovakia|European|Liechtenstein|Serbia|Yugoslav|Gibraltar|Miquelon|Soviet", MDGlong$Country)] = "Developed"
MDGlong$Region[MDGlong$Country %in% c("Armenia", "Azerbaijan", "Georgia", "Kazakhstan", 
        "Kyrgyzstan", "Tajikistan", "Turkmenistan", "Uzbekistan")] = 
        "Caucasus and Central Asia"
MDGlong$Region[MDGlong$Country %in% c("Algeria", "Egypt", "Libyan Arab Jamahiriya", 
        "Morocco", "Tunisia", "Western Sahara")] = "Northern Africa"
MDGlong$Region[MDGlong$Country %in% c("Angola", "Benin", "Botswana", "Burkina Faso", 
        "Burundi", "Cameroon", "Cape Verde", "Central African Rep", "Chad", "Comoros", 
        "Congo", "Cote d'Ivoire", "Dem Rep of the Congo", "Djibouti", "Equatorial Guinea", 
        "Eritrea", "Ethiopia", "Gabon", "Gambia", "Ghana", "Guinea", "Guinea-Bissau", 
        "Kenya", "Lesotho", "Liberia", "Madagascar", "Malawi", "Mali", "Mauritania", 
        "Mauritius", "Mayotte", "Mozambique", "Namibia", "Niger", "Nigeria", "Reunion", 
        "Rwanda", "Sao Tome & Principe", "Senegal", "Seychelles", "Sierra Leone", 
        "Somalia", "South Africa", "Sudan", "South Sudan", "Swaziland", "Togo", 
        "Uganda", "United Rep of Tanzania", "Zambia", "Zimbabwe")] = "Sub-Saharan Africa"
MDGlong$Region[grepl("Central African", MDGlong$Country) | 
        grepl("Sao Tome and Principe", MDGlong$Country) |
        grepl("Congo|Sudan|Tanzania|Helena", MDGlong$Country)] = "Sub-Saharan Africa"
MDGlong$Region[MDGlong$Country %in% c("Caribbean", "Anguilla", "Antigua and Barbuda", 
        "Aruba", "Bahamas", "Barbados", "British Virgin Islands", "Cayman Islands", "Cuba", 
        "Dominica", "Dominican Republic", "Grenada", "Guadeloupe", "Haiti", "Jamaica", 
        "Martinique", "Montserrat", "Netherlands Antilles", "Puerto Rico", 
        "Saint Kitts and Nevis", "Saint Lucia", "St Vincent & the Grenadines", 
        "Trinidad and Tobago", "Turks and Caicos Islands", "US Virgin Islands", 
        "Latin America", "Argentina", "Belize", "Bolivia", "Brazil", "Chile", "Colombia", 
        "Costa Rica", "Equador", "El Salvador", "Falkland Is (Malvinas)", "French Guiana", 
        "Guatamala", "Guyana", "Honduras", "Mexico", "Nicaragua", "Panama", "Paraguay", "Peru", 
        "Suriname", "Uruguay", "Venezuela")] = "Latin America and the Carribbean"
MDGlong$Region[grepl("Virgin Islands", MDGlong$Country) | 
        grepl("Saint Vincent", MDGlong$Country) | grepl("Guatemala|Ecuador|Falkland", MDGlong$Country)] = 
        "Latin America and the Carribbean"
MDGlong$Region[MDGlong$Country %in% c("China", "Hong Kong SAR of China", "Macao SAR of China", 
        "Korea, Dem People's Rep of", "Korea, Rep of", "Mongolia")] = "Eastern Asia"
MDGlong$Region[grepl("China|Korea", MDGlong$Country)] = "Eastern Asia"
MDGlong$Region[MDGlong$Country %in% c("Afghanistan", "Bangladesh", "Bhutan", "India", 
        "Iran (Islamic Republic of)", "Maldives", "Nepal", "Pakistan", "Sri Lanka")] = 
        "Southern Asia"
MDGlong$Region[MDGlong$Country %in% c("Brunei Darussalam", "Cambodia", "Indonesia", 
        "Lao People's Dem Repulic", "Malaysia", "Myanmar", "Philippines", "Singapore", 
        "Thailand", "Timor-Leste", "Viet Nam")] = "South-Eastern Asia"
MDGlong$Region[grepl("Lao", MDGlong$Country)] = "South-Eastern Asia"
MDGlong$Region[MDGlong$Country %in% c("Bahrain", "Iraq", "Jordan", "Kuwait", "Lebanon", 
        "Occupied Palestinian Territory", "Oman", "Qatar", "Saudi Arabia", 
        "Syrian Arab Republic", "Turkey", "United Arab Emirates", "Yemen")] = "Western Asia"
MDGlong$Region[grepl("Palestine", MDGlong$Country)] = "Western Asia"
MDGlong$Region[MDGlong$Country %in% c("American Samoa", "Cook Is", "Fiji", 
        "French Polynesia", "Guam", "Kiribati", "Marshall Islands", 
        "Micronesia (Fed States of)", "Nauru", "Niue", "New Caledonia", 
        "Northern Mariana Is", "Palau", "Papua New Guinea", "Samoa", "Solomon Is", 
        "Tokelau", "Tonga", "Tuvalu", "Vanuatu")] = "Oceania"
MDGlong$Region[grepl("Cook|Micronesia|Solomon|Mariana|Wallis", MDGlong$Country)] = "Oceania"


#Create a second data frame that counts number of data measurements for each SeriesCode by CountryCode
MDGcount = ddply(MDGlong, .(CountryCode, Country, SeriesCode, Series, Gender), 
                 summarise, Count=sum( !is.na(Value) ) )


#GET POPULATION DATA FROM http://esa.un.org/unpd/wpp/DVD/
popn <- read.csv("Data/WPP2015_POP.csv", stringsAsFactors=FALSE)
#Convert from wide to long format and create the variable "population"
#Keep cols with X1990, X1991, ... 
years = paste("X", seq(1990, 2015), sep="")
popnwide = popn
names(popnwide)[4:29] = gsub("X", "", names(popnwide)[4:29])
popnwide$Obs = rownames(popnwide)

#Reshape data wide to long
popnlong = reshape(popnwide, varying=c(4:29), direction="long", idvar="Obs",
                   times=1990:2015, timevar="Year", v.name="Population")
#Remove blank spaces from population numbers and convert to numeric
popnlong$Population = gsub(" ", "", popnlong$Population)
popnlong$Population = as.numeric(popnlong$Population)
popnlong = popnlong[,-c(3,4)]  #remove "Region" and "Obs"


#MERGE MDG data with population data
MDGp = merge(MDGlong, popnlong, by=c("CountryCode", "Year"))
MDGf = MDGp[,c(7, 3, 1, 10, 2, 4, 6, 8:9, 12)]
names(MDGf)[names(MDGf)=="Country.x"] = "Country"


#GET FINANCIAL DATA from http://data.worldbank.org/indicator/SH.XPD.TOTL.ZS (total health expenditore, % of GDP)
healthexp <- read.csv("Data/WorldBank_healthexpGDP.csv", stringsAsFactors=FALSE)
years = paste("X", seq(2000, 2013), sep="")
names(healthexp)[3:16] = gsub("X", "", names(healthexp)[3:16])
#Reshape to Country, Series, Year (from wide to long)
healthexp$Obs = rownames(healthexp)
hexplong = reshape(healthexp, varying=c(3:16), direction="long", idvar="Obs",
                  times=2000:2013, timevar="Year", v.name="HealthExpenditure")
#Merge financial data with MDGf
MDGff = merge(MDGf, hexplong, by=c("Country", "Year"), all.x=TRUE)


#RESHAPE so that Series and SeriesCode are columns - this works well with gvisMotionChart
MDGfw = dcast(MDGff, CountryCode + Country + Region + Year + Population + HealthExpenditure ~ Series + SeriesCode, value.var="Value")  #reshape2
MDGfw = MDGfw[,c(1:6, 13, 9, 17, 16, 18, 10, 11, 12, 14, 15, 7, 8)]
orign = names(MDGfw)
names(MDGfw) = c("Country Code", "Country", "Region", "Year", "Population", "Total Health Expenditure (% of GDP)",
                 orign[7:18])
names(MDGfw) = gsub("\\_[^ ]+", "", names(MDGfw))

theme_set = theme_grey()
theme_trend = theme(axis.text=element_text(size=14, face="bold"), 
                    axis.title.x=element_text(size=14, face="bold"), 
                    axis.title.y=element_text(size=14, face="bold"),
                    plot.title=element_text(size=16, face="bold"),
                    legend.text=element_text(size=12, face="bold"),
                    legend.title=element_text(size=14, face="bold"))


