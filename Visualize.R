require(ggplot2)
library("wordcloud")
library("RColorBrewer")
library("extrafont")
setwd('C:/Users/Jagannath/Desktop/Programming/Projects/Chat Visualiser/')

load('whatsapp_cleaned.Rdata')


#Conversations per hour
png("time_polar.png", width=2000,height=2000)
  ggplot(chat, aes(x = chat$time$hour, fill = name)) +
  stat_count(position = "dodge", show.legend = TRUE) +
  ggtitle("conversations per hour") +
  ylab("# of messages") + xlab("time") +
  theme(plot.title = element_text(lineheight = .8, face = "bold"))
dev.off()
#Word Cloud
 load('Text_cleaned.Rdata')

png("schoool_wordcloud.png", width=1920,height=1080)
wordcloud(words = d$word, freq =d$freq, min.freq=10,random.order=FALSE,
          rot.per=0.20, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"),family="Georgia", font=1)
dev.off()

#User Frequency
load('frequency.Rdata')
View(frequency)

  ggplot(frequency,aes(frequency$Var1,frequency$Freq))+ geom_bar(stat='identity',aes(fill=frequency$Var1),show.legend = FALSE) +
  ggtitle("User Activity") +
  ylab("# of Messages") + xlab("User") +
  coord_polar("x")+theme_bw()+theme(axis.text = element_text(size = 15))+theme(text = element_text(size = 10))
  
#Most active days
  load('date_frequency.Rdata')
  View(date_freq)
  ggplot(date_freq,aes(date_freq$Var1,date_freq$Freq))+geom_bar(stat='identity')
  
#most active months
  load('month_frequency.Rdata')

  ggplot(month_freq,aes(month_freq$Var1,month_freq$Freq)) + geom_bar(stat="identity")+coord_polar("x")
 
  
  