library("tidyverse")
library("leaflet")
library("dplyr")
library("leaflet.extras")

schoolsData <- as.data.frame(read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQRGIMjdnID_DgFPq9JT0KFql7TxngN7_u5IR3ji86aCdqm4_BEhtcxYMiiClXNSfl4zcQNpvhiGNa_/pub?gid=1989311314&single=true&output=csv"))

schoolsImproved <- schoolsData %>% filter(X..Change >= 0)
schoolsWorse <-schoolsData %>% filter(X..Change < 0)

pal <- colorBin(palette = "RdYlGn", domain = schoolsImproved$X2020....Pass, bins = 6,na.color = "#808080",)
pal1 <- colorBin(palette = "RdYlGn", domain = schoolsWorse$X2020....Pass, bins = 6, na.color = "#808080",)
pal3 <- colorBin(palette = "RdYlGn", domain = schoolsData$X2020....Pass, bins = 6, na.color = "#808080",)


m <- leaflet(options = leafletOptions(preferCanvas = FALSE)) %>%
  setView(lng = 24.47, lat = -28.47, zoom = 6)%>%
  addTiles(urlTemplate = "", attribution = 'Source: Department of Education. For any missing or inaccuracte reports, please contact talktous@mg.co.za')%>%
  addProviderTiles(providers$Stamen.TonerLite)%>%
  addCircleMarkers(data = schoolsImproved, lng = as.numeric(schoolsImproved$Longitude), lat = as.numeric(schoolsImproved$Latitude), label = schoolsImproved$School.name , popup = paste(
                                                                                                          "<b>", schoolsImproved$School.name, "</b>
                                                                                                          <br/><b>Quintile</b>", schoolsImproved$Quintile,
                                                                                                          "<br/><b>Students who sat exams</b>", schoolsImproved$X2020..Total.wrote,
                                                                                                          "<br/><b>Pass rate 2020</b>", schoolsImproved$X2020....Pass,"%
                                                                                                          <br/><b>Change year on year</b>", schoolsImproved$X..Change,
                                                                                                          "<br /><br><b>School type</b>", schoolsImproved$School.type), 
                  radius = schoolsImproved$Quintile, color = ~pal(schoolsImproved$X2020....Pass), group = "Improved over previous year") %>%
  addCircleMarkers(data = schoolsWorse, lng = as.numeric(schoolsWorse$Longitude), lat = as.numeric(schoolsWorse$Latitude), label = schoolsWorse$School.name , popup = paste(
    "<b>", schoolsWorse$School.name,
    "</b><br/><b>Quintile</b>", schoolsWorse$Quintile, 
    "<br/><b>Students who sat exams</b>", schoolsWorse$X2020..Total.wrote,
    "<br/><b>Pass rate 2020</b>", schoolsWorse$X2020....Pass,"%
     <br/><b>Change year on year</b>", schoolsWorse$X..Change,
    "<br /><br/><b>School type</b>", schoolsWorse$School.type), 
    radius = schoolsWorse$Quintile, color = ~pal1(schoolsWorse$X2020....Pass), group = "Worse than previous year") %>%
  addLayersControl(overlayGroups = c("Improved over previous year","Worse than previous year"), 
                   options = layersControlOptions(collapsed = FALSE))%>%


 addSearchFeatures(
 targetGroups = c("Improved over previous year","Worse than previous year"),
 options = searchFeaturesOptions(
  zoom = 10, openPopup = TRUE, firstTipSubmit = TRUE, collapsed = FALSE,  autoCollapse = FALSE, hideMarkerOnCollapse = TRUE ))

m

addLegend(map = m, data = schoolsData, "bottomright", pal = pal3, values = schoolsData$X2020....Pass, 
          title = "Dot size = Quintile<BR><BR>Pass rate (%)", na.label = "NA",
          opacity = 1)

 
 

