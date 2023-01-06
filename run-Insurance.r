# Setzen des Pfades und Einlesen der Beispiel-Daten, Daten anpassen
	
	setwd("D:/KI/3- WS/Assistenzsysteme/Hable/R-Codes_fuer_Shiny")
	Daten <- read.csv("insurance.dataset.csv",header=TRUE,sep=",",fill=TRUE,stringsAsFactors=TRUE)
	Daten[,"smoker"] <- as.factor(Daten[,"smoker"])
		
# Kontrolle der Datentypen und Ausgabe der Summary
	
	summary(Daten)
		
# Berechnung einer Regression 
  
	model <- lm( charges ~ age + sex + bmi + children + smoker + region, data=Daten)
	model
		
# Berechnung des mittleren Prognosefehlers (MAE)

    y <- Daten[,"charges"] 
    Prognosen <- model$fitted.values 
    Prognosefehler <- mean( abs( y - Prognosen ) )
    Prognosefehler
	
# Starten der Shiny-App

	library(shiny)
	library(shinythemes)
	runApp("App-Insurance")
