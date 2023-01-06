

# User Interface - UI	 
ui <- fluidPage(theme = shinytheme("united"),

# Titel der App
	titlePanel("Insurance charges in US"),
	
    navbarPage(
	  # Eine Überschrift
      strong("USICC"),
	  
	  # Ein TabPanel für die Hauptseite für die Darstellung, Prognosen und Vergleichen
      tabPanel("Main",
		# Layout für die Eingaben in die App und die Ausgaben
		sidebarLayout(
		
			# Die Definition der Eingabefelder auf der linken Seite
            sidebarPanel(
    
				# Fragen nach dem Anpassen der Attributen mit roter Linie darunter
				h4("Adjust attributes to calculate Your annual insurance charges",align="center"),
				hr(style="height: 2px; background: red"),
				
				# Fragen, ob der User schon versichert. Falls ja, wie viel bezhalt er dann zum Vergleichen.
				checkboxInput(inputId="gotInsurance", label="Do you have already insurance?", value = FALSE),
				numericInput(inputId="currentCharges", 
					label="If so, how much do you pay right now ?", 
						value = 0,
						min=1000,max=70000,step=500
				),
				
				# Eine rote Linie zum Style halt		
				hr(style="height: 2px; background: red"),

				# Ein Slider für das Alter, der von 18 (min) bis 90 (max) geht
				# Auf 20 (value) voreingestellt
				sliderInput(inputId = "age",
					label = "Age",
					min = 18,
					max = 90,
					value = 20
				),
				
				# Die Anzahl der Kinder numerische Eingabe. Es geht von 0 (keine Kinder) bis 10 (max).
				# die Voreinstellung ist 2 (value)
				numericInput(inputId="children", 
					label="Children:", 
						value = 2,
						min=0,max=10,step=1
				),
				
				# Ein Slider für BMI-Wert (Körpergewichtsindex)	von 10 bis 70. Auf 20 (normaler Mensch) voreingestellt.		
				sliderInput(inputId="bmi", 
					label="BMI (Body mass index)", 
						value = 20 ,
						min=10,max=70,step=1
				),
				
				# Das Geschlecht als Auswahlliste,  mänlich oder weiblich. 
				# Eigentlich spielt hier das Geschlecht als Faktor fast keine Rolle.
				selectInput("sex",label="Sex", 
					   choices = list("Female" = "female", "Male" = "male"
									  ), selected = "male"
				), 
				
				
				# Die Region als Auswahlliste
				selectInput("region",label="Region", 
						   choices = list("southwest" = "southwest", "southeast" = "southeast",
										  "northwest" = "northwest","northeast" = "northeast" ), selected = "northeast"
				), 
		  
				# eine Überschrift für Rauchensmerkmale
				h5(strong("Smoking?"),align="left"),
		  
				# Es wird hier festgelegt, ob der User raucht oder nicht mit einer Box zum Anklicken				
				# Ist auf FALSE voreingestellt
				checkboxInput(inputId="smoker", label="Smoker", value = FALSE),
				
				# Falls der User raucht, wird ihm beraten, Rauchen aufzuhören
				# Mit textOutput von der Funktion "StopSmoking"
				textOutput("StopSmoking"),
				
				br(),
				
				# Ein Button fürs Berechnen. Es wird erst aktualisiert, nachdem der User auf den SubmitButton gedrückt hat.
				submitButton("Caclculate!")
			),

			# der Hauptbereich der Nutzeroberfläche für die Ausgabe der Ergebnisse
			mainPanel(
				tabsetPanel(
					# Ein TabPanel für Ausgabe des Histogramms und Prognosen
					tabPanel("Diagram",
								# Ausgabe des Histogramms
								plotOutput(outputId = "Verteilung"),
								br(),
								# Ausgabe der Prognosen
								h4(textOutput("Prognose")),
								br()
					),
					
					# Ein TabPanel zum Verglichen mit den Kosten, die der User aktuell bezhalt
					tabPanel("Compare",
								br(),
								(textOutput("Compare")),	
					),
				)
			)
		)
               
      ),
	  # Ein TabPanel für eine kurze Beschreibung
      tabPanel("About",
		  sidebarLayout(
				   sidebarPanel(
						h1(strong(p("About", style = "text-align: center"))),
						br(),
						
						# Ein kleiner Hinweis, warum diese App entwickelt wurde
						h3(strong(p("Background"))),
						p(h5("Inurance is now obligatory so it's alaways good to know how much to pay in advance.")),
						h3(strong(p("About"))),
						p(h5("USICC is an app to predict your annual insurance charges depending on some criteria such as age, BMI etc.")),
						
						# Kurze Anleitung, wie der User die App benutzt
						h3(strong(p("How to use USICC ?"))),
						p(h5("You have to adjust the input attributes according to your specifications and you will get an approximate value of the annual insurance charges.")),
						
						# Fragen, ob die angegebenen Infos sinnvoll waren.
						selectInput("isUseful", label = strong(h3("Was that useful?" , style = "color:red")), 
											choices = list("Yes" = 1, "No" = 2),
											selected = 0),
						
						# Nach Feedback fargen
						textInput("improve", label = h3("How can we improve our service?"), placeholder = "Enter feedback..."),
						
						# Ein SubmitButton fürs Absenden des Feedbacks und der von User eingegebenen Antworten
						submitButton("Send !"),
						
					),
					
					# Ein Paar Fotos zum Style
					mainPanel(
						tags$img(src = "https://cdn-icons-png.flaticon.com/512/2966/2966334.png", width = "200px", height = "200px"),
						tags$img(src = "https://cdn-icons-png.flaticon.com/512/2966/2966470.png", width = "280px", height = "280px"),
						tags$img(src = "https://cdn-icons-png.flaticon.com/512/2966/2966486.png", width = "350px", height = "350px"),
					)
			)
		),
	  # Ein TabPanel für die Kontaktsdaten
	  tabPanel("Contact",
				br(),
				h2(strong("You can reach us under:")),
				h3(strong(HTML("&emsp;&emsp;"),"Telefon: "), "+1000000") ,
				h3(strong(HTML("&emsp;&emsp;"),"Webseite: "),a("www.USICC.com")),
				h3(strong(HTML("&emsp;&emsp;"),"E-Mail: "), "USICC@web.us") ,
				h3(strong(HTML("&emsp;&emsp;"),"Fax: "), "+1-212-9876543")				
		)			
    ) 
)








# Server Funktion
server <- function(input, output) {
	

  # Innerhalb dieser Funktion werden die Prognosen für die Ausgabe erzeugt und die Ergebnisse berechnet
  
  # Folgende Funktion berechnet die Prognose für die eingegeben Werte  
	prognose <- reactive({
	
			# Speichere die Daten der Einflussvariablen in ein Objekt X
			X <- Daten[,c("age", "sex","bmi","children","smoker","region")]
			
			# Ersetze die erste Zeile in X nun mit den neuen, eingegebenen Werten
				#zunächst die Werte für age, bmi und children
				X[1,"age"] <- input$age 
				X[1,"bmi"] <- input$bmi
				X[1,"children"] <- input$children
			
				# die angegebenen Werte für sex und region müssen zusätzlich noch in factor umgewandelt werden
				X[1,"sex"] <- as.factor(input$sex)
				X[1,"region"] <- as.factor(input$region)
			
			# die Eingabe TRUE/FALSE für das Merkmal "smoker" wird in 0/1-Variablen umgewandelt (mit ifelse) und in
			# den Datentyp factor umgewandelt (mit as.factor). Der Wert wird in die erste Zeile von X eingetragen
			X[1,"smoker"] <- as.factor(ifelse(input$smoker == FALSE, 0, 1))
			
			# Berechne die Prognosen für X
			# die Prognose der neuen, eingegebenen Werte stehen im ersten Eintrag des Prognosevektors
			prognosevektor <- predict(model,X)
			prog <- prognosevektor[1]
			
			# der Prognosewert wird noch auf 2 Stellen hinter dem Komma (digits = 2) gerundet.
			prog <- round(prog,digits=2)
			
			# Da es eine große MAE-Wert (4000 ungefähr) vorliegt, kann es manchmal zu negativen Ergebnissen kommen. Sollte es der Fall sein, wird 
			# der prognostizierte wert auf den minimalen Wert (1122) festgelegt
			if (prog <= 1122){
			prog = 1122}
						
			# der errechnete Wert soll als Ergebnis der Funktion zurückgegeben werden
			prog
		}
    )         
    
	
  # diese Funktion erzeugt das Histogramm und speichert es als Ausgabebild 
  # mit dem Namen output$Verteilung
  output$Verteilung <- renderPlot({

			# die errechnete Prognose aus der oben geschriebenen Funktion prognose()
			prog <- prognose()
			
			# Speichere die Daten der Einflussvariablen in ein Objekt X
			# und die Daten der Zielvariable in y.
			# Berechne dann die Abweichungen zwischen den Prognosen und den realen Werten
			X <- Daten[,c("age","sex","bmi","children","smoker","region")]
			y <- Daten[,"charges"]
			abweichungen <- y - predict(model,X)
			
			# Zeichne jetzt im Histogram die Prognose mit den Abweichungen
			# dies visualisiert die Bandbreite der Kosten für die Versicherung 
			hist(prog + abweichungen, col = "#FF5E0E", main = "Distribution", xlab= "Predictions + Variance")
		}
    )
  
  # Definition einer Textausgabe mit dem namen output$Prognose 
  # In dieser Textausgabe soll der in der Funktion prognose() 
  # errechnete Prognosewert ausgegeben werden
  output$Prognose <- renderText({
  
			# der Wert der Prognose aus der Funktion prognose()
			prog <- prognose()
		  
			# die Ausgabe ist eine Kombination von Text und dem errechneten Prognosewerts prog 
			Ausgabe <- paste("Your annual average charges would be about: " , prog,"$",".")
		}
    )
	
  # Eine Textausgabe zum Vergleichen. Wird in Seite "Compare" aufgerufen bzw. ausgegeben
  output$Compare <- renderText({
			# der Wert der Prognose wird nochmals mit der Funktion prognose() berechnet
			prog <- prognose()
			
			# Speichere die aktuellen Kosten zum Vergleichen
			currentCharges <- input$currentCharges
			
			# Es wird ein Text ausgegeben, je nach dem Vergleich
			Ausgabe <- paste("Your charges with us would be about " , prog, "$.", "You pay right now by your current insurance company "
							,currentCharges,"$.")
							
			# If Statement zum Vergleichen				
			if (prog < currentCharges){
				Ausgabe <- paste(Ausgabe,"That means it would be cheaper with us. If you willing to use our service please use Contact-Page")
			}
			else if (currentCharges == 0 ){
				Ausgabe <- paste("Please enter the current charges you pay to compare !")
			}
			else{
				Ausgabe <- paste(Ausgabe,"You will to have to pay ", prog - currentCharges , "$ more", 
										  "But we decrease the charges for our customers year by year, that means it could be in the long term cheaper.",
										  "To know more about our services visit our webseite under www.USICC.com")
			}  
		}
    )
   
  # Eine Textausgabe zum Rauchen. Wird ausgegeben, falls der User raucht
  output$StopSmoking <- renderText({
			if(input$smoker == TRUE){
				Ausgabe <- paste("Did you know that smoking, besides that it leads to death, it also drives up your Inurance costs.",
								 "ready to quit smoking?", "Visit: https://www.healthydelaware.org/")
			}
		}
    ) 
}







# Aufruf der App-Funktionen
shinyApp(ui = ui, server = server)








