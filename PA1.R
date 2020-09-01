library(ggplot2)
unzip("activity.zip")
dat <- read.csv("activity.csv")
dat$date <- as.Date(dat$date)
head(dat)

totalsteps <- aggregate(steps ~ date, dat, sum)
g1 <- ggplot(totalsteps, aes(steps))
p1 <- g1 + geom_histogram(bins = 25, fill = "orange")
print(p1)

mean(totalsteps$steps)
median(totalsteps$steps)

avgsteps <- aggregate(steps ~ interval, dat, mean)
head(avgsteps)

g2 <- ggplot(avgsteps, aes(interval, steps))
p2 <- g2 + geom_line()
print(p2)

avgsteps[which.max(avgsteps$steps),]$interval

sum(is.na(dat$steps))

datnew <- dat
for (i in 1:nrow(datnew)) {
    if (is.na(datnew$steps[i])) {
        datnew$steps[i] <- avgsteps[datnew$interval[i] == avgsteps$interval,2]
            }
}
head(datnew)

totalstepsnew <- aggregate(steps ~ date, datnew, sum)
g3 <- ggplot(totalsteps, aes(steps))
p3 <- g1 + geom_histogram(bins = 25, fill = "orange")
print(p3)

mean(totalstepsnew$steps)
median(totalstepsnew$steps)

for (i in 1:nrow(datnew)) {
    if(weekdays(datnew$date[i]) == "Sunday" | 
       weekdays(datnew$date[i]) == "Saturday") {
        datnew$day[i] <- "weekend"
    }else datnew$day[i] <- "weekday"
}
datnew$day <- as.factor(datnew$day)

g4 <- ggplot(datnew, aes(interval, steps))
p4 <- g4 + geom_line(stat = "summary", fun = "mean") +  facet_grid(day ~ .)
print(p4)
