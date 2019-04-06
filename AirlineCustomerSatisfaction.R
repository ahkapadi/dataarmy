original_data <- read.csv("Satisfaction Survey.csv")
cleaning_data <- original_data
cleaning_data$Satisfaction <- as.numeric(cleaning_data$Satisfaction)
# NA values found when changing data type, return the row number with na values and go back to the original data
which(is.na(cleaning_data$Satisfaction))
original_data$Satisfaction[c(38898,38899,38900)]
# "4.00.5"    "4.00.2.00" "4.00.2.00"  possible wrong data of satisfaction, considering deleting the three rows.
cleaning_data <- cleaning_data[-c(38898,38899,38900),]
# make sure the rows have been deleted
nrow(cleaning_data)
table(cleaning_data$Satisfaction)
# change the rating of 2.5 to 2, and 4.5 to 4
cleaning_data$Satisfaction[cleaning_data$Satisfaction == 2.5] <- 2
cleaning_data$Satisfaction[cleaning_data$Satisfaction == 3.5] <- 3
cleaning_data$Satisfaction[cleaning_data$Satisfaction == 4.5] <- 4

cleaning_data$Status2 <- cleaning_data$Airline.Status
cleaning_data$Status2 <- gsub("Blue",4, cleaning_data$Status2)
cleaning_data$Status2 <- gsub("Silver",3, cleaning_data$Status2)
cleaning_data$Status2 <- gsub("Gold",2, cleaning_data$Status2)
cleaning_data$Status2 <- gsub("Platinum",1, cleaning_data$Status2)
cleaning_data$Status2 <- as.numeric(cleaning_data$Status2)
cleaning_data$Airline.Status <- cleaning_data$Status2

cleaning_data$Gender2 <- cleaning_data$Gender
cleaning_data$Gender2 <- gsub('Female',1,cleaning_data$Gender2)
cleaning_data$Gender2 <- gsub('Male',0,cleaning_data$Gender2)
cleaning_data$Gender <- as.numeric(cleaning_data$Gender2)
str(cleaning_data)
table(cleaning_data$Gender,cleaning_data$Satisfaction)
gendertable <- table(cleaning_data$Satisfaction,cleaning_data$Gender)
prop.table(gendertable)

# Replacing NA values in Departure Delay with the mean value
cleaning_data$Departure.Delay.in.Minutes[is.na(cleaning_data$Departure.Delay.in.Minutes)] <- mean(cleaning_data$Departure.Delay.in.Minutes, na.rm=TRUE)
View(cleaning_data)
# Confirming that all the NA values are removed
sum(is.na(cleaning_data$Departure.Delay.in.Minutes))
# Replacing NA values in Arrival Delay with the mean value
cleaning_data$Arrival.Delay.in.Minutes[is.na(cleaning_data$Arrival.Delay.in.Minutes)] <- mean(cleaning_data$Arrival.Delay.in.Minutes, na.rm=TRUE)
View(cleaning_data)
# Confirming that all the NA values are removed
sum(is.na(cleaning_data$Arrival.Delay.in.Minutes))

#check the type of data in the column
typeof(cleaning_data$No.of.Flights.p.a.)
#Function to replace .,
cleanfunction <- function(cleanset)
{
  cleanset <- gsub(",","",cleanset)
  cleanset <- gsub(" ","",cleanset)
  return(cleanset)
}
cleaning_data$Class <- cleanfunction(cleaning_data$Class)
cleaning_data$No.of.Flights.p.a.<- cleanfunction(cleaning_data$No.of.Flights.p.a.)
cleaning_data$No.of.Flights.p.a.<-as.numeric(cleaning_data$No.of.Flights.p.a.)

cleaning_data$Class2 <- cleaning_data$Class
cleaning_data$Class2 <- gsub("Business",1, cleaning_data$Class2)
cleaning_data$Class2 <- gsub("Eco Plus",2, cleaning_data$Class2)
cleaning_data$Class2 <- gsub("Eco",3, cleaning_data$Class2)
cleaning_data$Class <- cleaning_data$Class2
cleaning_data$Class2
cleaning_data$Class <- as.numeric(cleaning_data$Class)

cleanfunction <- function(a)
{
  a <- gsub(",","",a)
  a <- gsub(" ","",a)
}

cleaning_data$Price.Sensitivity<-as.numeric(cleanfunction(cleaning_data$Price.Sensitivity))
cleaning_data$X..of.Flight.with.other.Airlines <- as.numeric(cleanfunction(cleaning_data$X..of.Flight.with.other.Airlines))
cleaning_data$Type.of.Travel <- cleanfunction(cleaning_data$Type.of.Travel)
#Change Type of Travel to numeric (Businesstravel = 1, PersonalTravel = 2, Mileagetickets = 3)
cleaning_data$Type.of.Travel2 <- cleaning_data$Type.of.Travel
cleaning_data$Type.of.Travel2 <- gsub("Businesstravel",1, cleaning_data$Type.of.Travel2)
cleaning_data$Type.of.Travel2 <- gsub("PersonalTravel",2, cleaning_data$Type.of.Travel2)
cleaning_data$Type.of.Travel2 <- gsub("Mileagetickets",3, cleaning_data$Type.of.Travel2)
cleaning_data$Type.of.Travel <- cleaning_data$Type.of.Travel2
cleaning_data$Type.of.Travel <- as.numeric(cleaning_data$Type.of.Travel)
cleaning_data$Flight.cancelled2 <- cleaning_data$Flight.cancelled
cleaning_data$Flight.cancelled2 <- gsub("Yes",1, cleaning_data$Flight.cancelled2)
cleaning_data$Flight.cancelled2 <- gsub("No",0, cleaning_data$Flight.cancelled2)
cleaning_data$Flight.cancelled <- cleaning_data$Flight.cancelled2
cleaning_data$Flight.cancelled <- as.numeric(cleaning_data$Flight.cancelled)
#change data type of flight distance to numeric (or make sure everything is numeric)
cleaning_data$Flight.Distance <- as.numeric(cleaning_data$Flight.Distance)

sum(is.na(cleaning_data))
sum(is.na(cleaning_data$Flight.time.in.minutes))
time.mean <- mean(cleaning_data$Flight.time.in.minutes, na.rm=TRUE)
cleaning_data$Flight.time.in.minutes[is.na(cleaning_data$Flight.time.in.minutes)] = time.mean
sum(is.na(cleaning_data))

flightdate <- cleaning_data$Flight.date
flightdate
length(flightdate)
flight_month <- c()
flight_date <- c()
flight_year <- c()
for (i in (1:length(flightdate))) {
  cleaning_date <- gsub('200','',flightdate[i])
  flight_month[i] <- substr(cleaning_date,1,1)
  flight_date[i] <- gsub('/','',substr(cleaning_date,3,4))
  flight_year[i] <- substr(cleaning_date,nchar(cleaning_date)-1,nchar(cleaning_date))
}
flight_date
flight_year
flight_month
cleaning_data$Flight.year <- flight_year
cleaning_data$Flight.month <- flight_month
cleaning_data$Flight.day <- as.numeric(flight_date)
View(cleaning_data)
str(cleaning_data)

# find out the state with the most frequent flights us the 50 percentile
state <- table(cleaning_data$Origin.State)
state[order(state,decreasing = TRUE)]
vBuckets <- replicate(length(state),'Not Busy')
vBuckets[state > quantile(state,0.5)] <- 'Busy'
vBuckets
busystates <- rownames(state[vBuckets == 'Busy'])
Busystates
# map the state to categories
busystate_origin <- replicate(nrow(cleaning_data),0)
busystate_destin <- replicate(nrow(cleaning_data),0)
for (i in 1:26) {
  busystate_origin[cleaning_data$Origin.State == busystates[i]] <- 1
  busystate_destin[cleaning_data$Destination.State == busystates[i]] <-1
  table(busystates)
}
table(busystate_origin)
table(busystate_destin)

# create a vector busystate
# if busystate = 0, not busy -> not busy
# if busystate = 1, busy state -> not busy or not busy -> busy
# if busystate = 2, busy state -> busy state
busystate <- busystate_origin + busystate_destin
busystate
cleaning_data$busystate <- busystate
cleaning_data$busystate
table(busystate)

# group by airline
library(dplyr)
groupedAirlines <- group_by(cleaning_data, cleaning_data$Airline.Name)
satisfaction <- summarize(groupedAirlines,count = n())
satisfaction

satisfaction$`cleaning_data$Airline.Name`
noAirlien <- nrow(satisfaction)
airline <- cleaning_data$Airline.Status
satisfactionRate <- replicate(noAirlien,0)
satisfactionRate

# get each airline's satisfaction average differene with the overall average and record count
for (i in c(1:noAirlien)) {  
  satPerAirline <- cleaning_data[cleaning_data$Airline.Name == satisfaction$`cleaning_data$Airline.Name`[i],]
  sat <- mean(satPerAirline[,1])
  satisfactionRate[i] <- sat
}

satisfactionRate
airLineSat <- data.frame(satisfaction$`cleaning_data$Airline.Name`,satisfactionRate)
airLineSat
average <- mean(airLineSat$satisfactionRate)
airLineSat$average <- average
airLineSat$Diff <- airLineSat$satisfactionRate - airLineSat$average
airLineSat  
str(airLineSat)
airLineSat$count <- satisfaction$count

# plot for satisfaction distribution
library(ggplot2)
AirlineSat <- ggplot(data = airLineSat, aes(x = reorder(airLineSat$satisfaction..cleaning_data.Airline.Name.,airLineSat$Diff), y= airLineSat$Diff)) + 
  geom_col() +xlab('Airline') + ylab('Airline average - overall average') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle('Airline average vs. overall average in satisfaction')
AirlineSat

# plot for record count
AirlineAmount <- ggplot(data = airLineSat, aes(x = reorder(airLineSat$satisfaction..cleaning_data.Airline.Name., airLineSat$count), y=airLineSat$count)) +
  geom_col() + xlab('Airline') + ylab('Count') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle('Record Count vs. Airline')
AirlineAmount

# create buckets for variables
createBucket <- function(vec){
  # create a list with a length as the original vector, each element is 'Average'
  vBuckets <- replicate(length(vec),'Average')
  # for those that are above the value 3, change the element with the same index in the new vector to 'High'
  vBuckets[vec==5] <- 'High'
  # for those that are below the value 4, change the element with the same index in the new vetor to 'Low'
  vBuckets[vec==4] <- 'High'
  vBuckets[vec==3] <- 'Low'
  vBuckets[vec==2] <- 'Low'
  vBuckets[vec==1] <- 'Low'
  return(vBuckets)
}

createBucket1 <- function(vec){
  # create a list with a length as the original vector, each element is 'Average'
  vBuckets <- replicate(length(vec),'Average')
  # for those that are above the value 3, change the element with the same index in the new vector to 'High'
  vBuckets[vec>=2] <- 'High'
  # for those that are below the value 4, change the element with the same index in the new vetor to 'Low'
  vBuckets[vec<2] <- 'Low'
  return(vBuckets)
}

# for variables with no 0-10 scale
createBucket2 <- function(vec){
  # use the same function as above, changing the interval point of 7 to the 40 and 60 percentile of the vector.
  q <- quantile(vec,c(0.33,0.66))
  vBuckets <- replicate(length(vec),'Average')
  vBuckets[vec <= q[1]] <- 'Low'
  vBuckets[vec >= q[2]] <- 'High'
  return(vBuckets)
}

# for delay
createBucketDelay <- function(vec){
  # use the same function as above, changing the interval point of 7 to the 40 and 60 percentile of the vector.
  q <- quantile(vec,c(0.33,0.66))
  vBuckets <- replicate(length(vec),'High')
  vBuckets[vec <= 5] <- 'Low'
  vBuckets[vec == 0] <- 'No delay'
  return(vBuckets)
}

summary(cleaning_data$Price.Sensitivity)
summary(cleaning_data$Departure.Delay.in.Minutes)

satisfactionB <- createBucket(cleaning_data$Satisfaction)
satisfactionB
AgeB <- createBucket2(cleaning_data$Age)
Price.SensitivityB <- createBucket1(cleaning_data$Price.Sensitivity)
Year.of.First.FlightB <- createBucket2(cleaning_data$Year.of.First.Flight)
No.of.Flights.p.a.B <- createBucket2(as.numeric(cleaning_data$No.of.Flights.p.a.))
X..of.Flight.with.other.AirlinesB <- createBucket2(cleaning_data$X..of.Flight.with.other.Airlines)
No..of.other.Loyalty.CardsB <- createBucket2(cleaning_data$No..of.other.Loyalty.Cards)
Day.of.MonthB <- createBucket2(cleaning_data$Day.of.Month)
Departure.Delay.in.MinutesB <- createBucketDelay(cleaning_data$Departure.Delay.in.Minutes)  
Arrival.Delay.in.MinutesB <- createBucketDelay(cleaning_data$Arrival.Delay.in.Minutes)
Flight.time.in.minutesB <- createBucket2(cleaning_data$Flight.time.in.minutes)
Flight.DistanceB <- createBucket2(cleaning_data$Flight.Distance)

rulesSetLow <- apriori(bucketdData, parameter = list(support = 0.25, confidence = 0.25),appearance = list(default = 'lhs', rhs = 'satisfactionB=Low'))
inspect(rulesSetLow)

rulesSetHigh <- apriori(bucketdData, parameter = list(support = 0.3, confidence = 0.25),appearance = list(default = 'lhs', rhs = 'satisfactionB=High'))
inspect(rulesSetHigh)

# West Airways Inc. 
westAirways <- bucketdData[bucketdData$cleaned_data.airlineName == 'West Airways Inc. ',]
WestSetHigh <- apriori(bucketdData, parameter = list(support = 0.25, confidence = 0.25),appearance = list(default = 'lhs', rhs = 'satisfactionB=High'))
inspect(rulesSetHigh)

# calculate each airline's average departure and arrival delay minutes
noairline
DdelayMinute <- replicate(noairline,0)
AdelayMinute <- replicate(noairline,0)
for (i in c(1:noairline)) {
  delayPerAirline <- cleaning_data[cleaning_data$Airline.Name == satisfaction$`cleaning_data$Airline.Name`[i],]
  departuredelay <- mean(delayPerAirline[,23])
  arrivaldelay <- mean(delayPerAirline[,24])
  DdelayMinute[i] <- departuredelay
  AdelayMinute[i] <- arrivaldelay
}
DdelayMinute
AdelayMinute
delay.airline <- data.frame(satisfaction$`cleaning_data$Airline.Name`,DdelayMinute,AdelayMinute)
delay.airline

# visualize average departure delay minutes in barplot
averageDDelay <- ggplot(data = delay.airline, aes(x = reorder(delay.airline$satisfaction..cleaning_data.Airline.Name.,delay.airline$DdelayMinute), y=delay.airline$DdelayMinute)) +
  geom_col() + xlab('Airline') + ylab('Average departure delay in minutes') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle('Average departure delay in minutes vs. Airline')
averageDDelay

# visualize average arrival delay minutes in barplot
averageADelay <- ggplot(data = delay.airline, aes(x = reorder(delay.airline$satisfaction..cleaning_data.Airline.Name.,delay.airline$AdelayMinute), y=delay.airline$AdelayMinute)) +
  geom_col() + xlab('Airline') + ylab('Average arrival delay in minutes') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle('Average arrival delay in minutes vs. Airline')
averageADelay

# traveller type vs. airline
p_businessTravel <- replicate(noairline,0)
for (i in c(1:noairline)) {
  typeAirline <- cleaning_data[cleaning_data$Airline.Name == satisfaction$`cleaning_data$Airline.Name`[i],]
  typeTravel <- typeAirline[,9]
  typeBusiness <- which(typeTravel==1)
  percent <- length(typeBusiness)/satisfaction$count[i]
  p_businessTravel[i] <- percent
}
type_b <- data.frame(satisfaction$`cleaning_data$Airline.Name`,p_businessTravel)
type_b

# traveller gender vs. airline
p_male <- replicate(noairline,0)
for (i in c(1:noairline)) {
  genderAirline <- cleaning_data[cleaning_data$Airline.Name == satisfaction$`cleaning_data$Airline.Name`[i],]
  gender <- genderAirline[,4]
  male <- which(gender==2)
  percent <- length(male)/satisfaction$count[i]
  p_male[i] <- percent
}
type_b <- data.frame(satisfaction$`cleaning_data$Airline.Name`,p_male)
type_b

# GoingNorth Airlines Inc.
goingNorth <- bucketdData[bucketdData$cleaned_data.airlineName == 'GoingNorth Airlines Inc. ',]
gNSetLow <- apriori(bucketdData, parameter = list(support = 0.25, confidence = 0.25),appearance = list(default = 'lhs', rhs = 'satisfactionB=Low'))
inspect(rulesSetLow)

#Create a new copy to test with:
test_data <- cleaned_data
View(test_data)
summary(test_data)

#Convert the following variables to dummy variables: Airline.Status, Type.of.Travel, Class

#Airline.Status
#Create new dummy variables: Blue, Silver, Gold, Platinum
#(currently Blue=4, Silver=3, Gold=2, Platinum=1)

test_data$Blue <- test_data$Airline.Status
test_data$Blue <- test_data$Airline.Status == 4
test_data$Blue[test_data$Blue=="TRUE"] <- 1
test_data$Blue[test_data$Blue=="FALSE"] <- 0

test_data$Silver <- test_data$Airline.Status
test_data$Silver <- test_data$Airline.Status == 3
test_data$Silver[test_data$Silver=="TRUE"] <- 1
test_data$Silver[test_data$Silver=="FALSE"] <- 0

test_data$Gold <- test_data$Airline.Status
test_data$Gold <- test_data$Airline.Status == 2
test_data$Gold[test_data$Gold=="TRUE"] <- 1
test_data$Gold[test_data$Gold=="FALSE"] <- 0

test_data$Platinum <- test_data$Airline.Status
test_data$Platinum <- test_data$Airline.Status == 1
test_data$Platinum[test_data$Platinum=="TRUE"] <- 1
test_data$Platinum[test_data$Platinum=="FALSE"] <- 0

#Class
#Create dummy variables: Economy, Eco_Plus, & Business
#(Currently Business = 1, Eco Plus = 2, Economy = 3)

test_data$Economy <- test_data$Class
test_data$Economy <- test_data$Class == 3
test_data$Economy[test_data$Economy=="TRUE"] <- 1
test_data$Economy[test_data$Economy=="FALSE"] <- 0

test_data$Eco_Plus <- test_data$Class
test_data$Eco_Plus <- test_data$Class == 2
test_data$Eco_Plus[test_data$Eco_Plus=="TRUE"] <- 1
test_data$Eco_Plus[test_data$Eco_Plus=="FALSE"] <- 0

test_data$BusinessClass <- test_data$Class
test_data$BusinessClass <- test_data$Class == 1
test_data$BusinessClass[test_data$BusinessClass=="TRUE"] <- 1
test_data$BusinessClass[test_data$BusinessClass=="FALSE"] <- 0

#Type.of.Travel
#Create dummy variables: MileageTix, Personal, Business 
#(Currently Mileagetickets = 3, PersonalTravel = 2, Businesstravel = 1)

test_data$MileageTix <- test_data$Type.of.Travel
test_data$MileageTix <- test_data$Type.of.Travel == 3
test_data$MileageTix[test_data$MileageTix=="TRUE"] <- 1
test_data$MileageTix[test_data$MileageTix=="FALSE"] <- 0

test_data$Personal <- test_data$Type.of.Travel
test_data$Personal <- test_data$Type.of.Travel == 2
test_data$Personal[test_data$Personal=="TRUE"] <- 1
test_data$Personal[test_data$Personal=="FALSE"] <- 0

test_data$Business <- test_data$Type.of.Travel
test_data$Business <- test_data$Type.of.Travel == 1
test_data$Business[test_data$Business=="TRUE"] <- 1
test_data$Business[test_data$Business=="FALSE"] <- 0

#Then we deleted the character rows by copying to a new data set since we will need to use the Airline Name variable later.
str(test_data)
ALLdata <- test_data[,-c(15:21)]

mALL <- lm(formula = Satisfaction ~ ., data = ALLdata)
summary(mALL)

#Price.Sensitivity - create a dummy variable for Price Sensitivity
#Create dummy variables: Sensitive, Not Sensitive
#(Currently Price.Sensitivity = 0:5 - 0 as not price sensitive (insensitive))

test_data$Sensitive <- test_data$Price.Sensitivity
test_data$Sensitive <- test_data$Price.Sensitivity > 1
test_data$Sensitive[test_data$Sensitive=="TRUE"] <- 1
test_data$Sensitive[test_data$Sensitive=="FALSE"] <- 0

test_data$NotSensitive <- test_data$Price.Sensitivity
test_data$NotSensitive <- test_data$Price.Sensitivity < 2
test_data$NotSensitive[test_data$NotSensitive=="TRUE"] <- 1
test_data$NotSensitive[test_data$NotSensitive=="FALSE"] <- 0

#Filter by Personal travellers and copy into a new data set
ALLdataPers <- subset(ALLdata, Personal == 1)
mALLPers <- lm(formula = Satisfaction ~ Age + Gender + No.of.Flights.p.a. + X..of.Flight.with.other.Airlines + No..of.other.Loyalty.Cards + Shopping.Amount.at.Airport + Eating.and.Drinking.at.Airport + Day.of.Month + Scheduled.Departure.Hour + Departure.Delay.in.Minutes + Arrival.Delay.in.Minutes + Flight.cancelled + Flight.time.in.minutes + Flight.Distance + busystate  + Gold + Blue + Platinum + Eco_Plus + Economy + NotSensitive, data = ALLdataPers)
summary(mALLPers)

ALLdataBus <- subset(ALLdata, Business == 1)
mALLBus <- lm(formula = Satisfaction ~ Age + Gender + No.of.Flights.p.a. + X..of.Flight.with.other.Airlines + No..of.other.Loyalty.Cards + Shopping.Amount.at.Airport + Eating.and.Drinking.at.Airport + Day.of.Month + Scheduled.Departure.Hour + Departure.Delay.in.Minutes + Arrival.Delay.in.Minutes + Flight.cancelled + Flight.time.in.minutes + Flight.Distance + busystate + Gold + Silver + Platinum + Eco_Plus + BusinessClass + NotSensitive, data = ALLdataBus)
summary(mALLBus)

R-squared is too low 0.102 so we will try another variable.
Code Snippet:
  ALLNoDelay <- ALLdata
ALLNoDelay <- subset(ALLNoDelay, ALLNoDelay$Arrival.Delay.in.Minutes == 0 & ALLNoDelay$Departure.Delay.in.Minutes == 0)
mALLNoDel <- lm(formula = Satisfaction ~ Age + Gender + No.of.Flights.p.a. + X..of.Flight.with.other.Airlines + No..of.other.Loyalty.Cards + Shopping.Amount.at.Airport + Eating.and.Drinking.at.Airport  + Day.of.Month + Scheduled.Departure.Hour + Flight.cancelled + Flight.time.in.minutes + Flight.Distance + busystate + Silver + Gold + Platinum + Eco_Plus + BusinessClass + Business + MileageTix + NotSensitive, data = ALLNoDelay)
summary(mALLNoDel)

#change data type of flight distance to numeric (or make sure everything is numeric)
cleaning_data$Flight.Distance <- as.numeric(cleaning_data$Flight.Distance)
cleaning_data$Arrival.Delay.greater.5.Mins2 <- cleaning_data$Arrival.Delay.greater.5.Mins
cleaning_data$Arrival.Delay.greater.5.Mins2 <- gsub("yes",1, cleaning_data$Arrival.Delay.greater.5.Mins2)
cleaning_data$Arrival.Delay.greater.5.Mins2 <- gsub("no",0, cleaning_data$Arrival.Delay.greater.5.Mins2)
cleaning_data$Arrival.Delay.greater.5.Mins <- cleaning_data$Arrival.Delay.greater.5.Mins2
cleaning_data$Arrival.Delay.greater.5.Mins <- as.numeric(cleaning_data$Arrival.Delay.greater.5.Mins)
str(cleaning_data)
cleaned_data <- cleaning_data[,-c(33:38)]
cleaned_data <- cleaned_data[,-c(30:32)]
cleaned_data <- cleaned_data[,-c(18:21)]
cleaned_data <- cleaned_data[,-c(15:21)]
str(cleaned_data)
test_data <- cleaned_data

modelAllNew <- lm(formula = Satisfaction ~ Age + Year.of.First.Flight + No.of.Flights.p.a. + No..of.other.Loyalty.Cards + Day.of.Month + Scheduled.Departure.Hour + Flight.cancelled + Arrival.Delay.greater.5.Mins + busystate + Silver + Gold + BusinessClass + MileageTix + Business + Sensitive, data = test_data)

svmOutput <- ksvm(satisfactionB~cleaned_data.Gender+cleaned_data.Type.of.Travel, data=trainData, kernel = 'rbfdot',kpar = 'automatic',C=3,cross =3, prob.model = TRUE)
svmOutput
svmPredict <- predict(svmOutput,testData,type='votes')
compTable <- data.frame(testData[,1],svmPredict[1,])
tab <- table(compTable)
error <- tab[1,1] + tab[2,2]
precision <- 1 - error/sum(tab)
Precision

svmOutput2 <- ksvm(satisfactionB~cleaned_data.Gender+cleaned_data.Type.of.Travel+cleaned_data.Airline.Status, data=trainData, kernel = 'rbfdot',kpar = 'automatic',C=3,cross =3, prob.model = TRUE)
svmOutput2
svmPredict2 <- predict(svmOutput2,testData,type='votes')
compTable2 <- data.frame(testData[,1],svmPredict2[1,])
tab2 <- table(compTable2)
error2 <- tab2[1,1] + tab2[2,2]
precision2 <- 1 - error2/sum(tab2)
precision2

