library("tm")
setwd('C:/Users/Jagannath/Desktop/Programming/Projects/Chat Visualiser/')

chat<-read.csv("chat_bonkers.csv",header = FALSE,
               na.strings="", stringsAsFactors = FALSE)
View(chat)
#Delete column 3, contains only "-"
chat <- chat[,-3]

#Merge columns 1 and 2 (date and time) to simplify things
chat[,1] <- paste(chat[,1], chat[,2])
#Remove now redundant second column
chat <- chat[,-2]
chat <-chat[,-2]
#Remove the first row
chat<-chat[-1,]
#Name the first three columns
colnames(chat)[1:3] <- c("time", "name", "surname")

#Remove the colon at the end of the names

chat$name <- gsub(":$", "", chat$name)
chat$surname <- gsub(":$", "", chat$surname)

#Convert the first column into a 'Posixlt' object.
chat$time <- strptime(chat$time,'%d/%m/%Y, %H:%M')
View(chat)
save(chat, file = "whatsapp_cleaned.Rdata")

#Making data frame for finding frequency of users
freq=as.data.frame( chat[,2])
tab=table(unlist(freq))
frequency=as.data.frame(tab) 
frequency<-subset(frequency,Freq>100)
View(frequency)
save(frequency, file = "frequency.Rdata")

#Making data frame for finding frequency of time

chat$time <- strptime(chat$time,'%Y-%m-%d')
date_freq <- as.data.frame((chat[,1]))
date_freq<-as.data.frame(table(format(date_freq$`(chat[, 1])`,'%Y-%m-%d')))
date_freq<-date_freq[order(-date_freq$Freq),]
date_freq<-date_freq[1:5,]
View(date_freq)
save(date_freq, file = "date_frequency.Rdata")

#Making data frame for finding frequency of months

chat$time <- format(chat$time,"%Y-%b")
month_freq <- as.data.frame((chat[,1]))
require(zoo)
month_freq<-as.data.frame(table(unlist(month_freq)))
View(month_freq)
save(month_freq, file = "month_frequency.Rdata")

#Removing time,name coloumns for text mining

chat <-chat[,-1]
chat <-chat[,-1]
chat <-chat[,-1]
View(chat)
#Writing the csv file back to a text file
write.table(chat, "chat_cleaned.txt",na="",append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = FALSE)

raw_text <- readLines("chat_cleaned.txt")
text_corpus<-Corpus(VectorSource(raw_text))

inspect(text_corpus)

#Replacing special chars
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
text_corpus <- tm_map(text_corpus, toSpace, "/")
text_corpus <- tm_map(text_corpus, toSpace, "@")
text_corpus <- tm_map(text_corpus, toSpace, "\\|")
text_corpus <- tm_map(text_corpus,toSpace,"\t")
text_corpus <- tm_map(text_corpus,removeNumbers)
text_corpus <- tm_map(text_corpus, content_transformer(tolower))

text_corpus <- tm_map(text_corpus,removeWords,stopwords("english"))
text_corpus <- tm_map(text_corpus,removeWords,c("ря~","media","omitted","https","will","know"))

docTermMat <-TermDocumentMatrix(text_corpus)
mat <-as.matrix(docTermMat)
v <- sort(rowSums(mat),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

View(d)
d <-d[-1,]

save(d, file = "Text_cleaned.Rdata")
