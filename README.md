# Machine_Learning

USICC is an application which predicts annual insurance fees using machine learning with the programming language R. The training process is based on a dataset of 1338 entries. The attributes are age, sex, BMI, number of children, smoker and region. A linear regression model will be trained then gives the predicted fee, which is "charges" with a MAE (mean absolute error)

### "app.r" is the file in which the user interface, the logic of the app, the server function with the help of "R Shiny" will be handled.

### the file "run-Insurance.r" is responsible for reading the dataset, adjusting the attributes in the right form, training the model, calculating the MAE value and running the whole app

### "insurance.dataset.csv" is the dataset
