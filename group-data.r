library(glue)

data <- read.csv('data.csv')
grouped_data <- aggregate(data[, 4:6], list(data$complexity, data$atoms), mean)
grouped_data$runtime <- round(grouped_data$runtime, digits=1)
grouped_data$states <- round(grouped_data$states, digits=1)
grouped_data$edges <- round(grouped_data$edges, digits=1)

for (row in 1:nrow(grouped_data)) {
    complexity <- grouped_data$Group.1[row]
    atoms <- grouped_data$Group.2[row]

    print(glue("{complexity},{atoms}"))
}

