#install.packages("tidyverse")
#install.packages("leaflet")
#install.packages("leafgl")
#install.packages("leafet-extras")

library("tidyverse")
library("leaflet")
library("dplyr")
library("leafgl")
library("leaflet.extras")

schoolsData <- as.data.frame(read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQRGIMjdnID_DgFPq9JT0KFql7TxngN7_u5IR3ji86aCdqm4_BEhtcxYMiiClXNSfl4zcQNpvhiGNa_/pub?gid=1989311314&single=true&output=csv"))

schoolsImproved <- schoolsData %>% filter(X..Change >= 0)
schoolsWorse <-schoolsData %>% filter(X..Change < 0)

pal <- colorBin(palette = "RdYlGn", domain = schoolsImproved$X2020....Pass, bins = 6,na.color = "#808080",)
pal1 <- colorBin(palette = "RdYlGn", domain = schoolsWorse$X2020....Pass, bins = 6, na.color = "#808080",)
pal3 <- colorBin(palette = "RdYlGn", domain = schoolsData$X2020....Pass, bins = 6, na.color = "#808080",)


m <- leaflet(options = leafletOptions(preferCanvas = FALSE)) %>%
  setView(lng = 24.47, lat = -28.47, zoom = 6)%>%
  addProviderTiles(providers$Stamen.TonerLite)%>%
  addCircleMarkers(data = schoolsImproved, lng = as.numeric(schoolsImproved$Longitude), lat = as.numeric(schoolsImproved$Latitude), label = schoolsImproved$School.name , popup = paste(
                                                                                                          "<b>School</b>:", schoolsImproved$School.name,
                                                                                                          "<br/><b>Quintile</b>:", schoolsImproved$Quintile, 
                                                                                                          "<br/><b>Pass rate 2020</b>:", schoolsImproved$X2020....Pass,
                                                                                                          "<br/><b>Change y-o-y</b>", schoolsImproved$X..Change), 
                  radius = schoolsImproved$Quintile, color = ~pal(schoolsImproved$X2020....Pass), group = "Improved") %>%
  addCircleMarkers(data = schoolsWorse, lng = as.numeric(schoolsWorse$Longitude), lat = as.numeric(schoolsWorse$Latitude), label = schoolsWorse$School.name , popup = paste(
    "<b>School</b>:", schoolsWorse$School.name,
    "<br/><b>Quintile</b>:", schoolsWorse$Quintile, 
    "<br/><b>Pass rate 2020</b>:", schoolsWorse$X2020....Pass,
    "<br/><b>Change y-o-y</b>", schoolsWorse$X..Change), 
    radius = schoolsWorse$Quintile, color = ~pal1(schoolsWorse$X2020....Pass), group = "Worse") %>%
  addLayersControl(overlayGroups = c("Improved","Worse"), 
                   options = layersControlOptions(collapsed = FALSE))%>%

#  addSearchOSM(options = searchOptions(hideMarkerOnCollapse = TRUE, zoom = 7)) 
  
 addSearchFeatures(
 targetGroups = c("Improved","Worse"),
 options = searchFeaturesOptions(
  zoom = 10, openPopup = TRUE, firstTipSubmit = TRUE, collapsed = FALSE,  autoCollapse = FALSE, hideMarkerOnCollapse = TRUE ))

 addLegend(map = m, data = schoolsData, "bottomright", pal = pal3, values = schoolsData$X2020....Pass, 
          title = "Pass rate", na.label = "NA",
          opacity = 1)

 
 
m

#  addCircleMarkers(lng = schoolsData$New.Long, lat = schoolsData$New.Lat, popup = schoolsData$Institution_Name, color = schoolsData$Quintile)

m <- leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
  addTiles()%>%
  addMarkers(lng=30.33409, lat=-23.67264)
