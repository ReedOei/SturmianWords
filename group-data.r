require(glue)

data <- read.csv('data.csv')
data$num = 1
grouped_data <- aggregate(data[, 4:7], list(data$complexity, data$atoms), sum)
grouped_data$runtime <- round(grouped_data$runtime / grouped_data$num, digits=1)
grouped_data$states <- round(grouped_data$states / grouped_data$num, digits=1)
grouped_data$edges <- round(grouped_data$edges / grouped_data$num, digits=1)

for (row in 1:nrow(grouped_data)) {
    complexity <- grouped_data$Group.1[row]
    atoms <- grouped_data$Group.2[row]
    num <- grouped_data$num[row]
    runtime <- format(grouped_data$runtime[row], nsmall=1)
    states <- format(grouped_data$states[row], nsmall=1)
    edges <- format(grouped_data$edges[row], nsmall=1)

    print(glue("${complexity}$ & ${atoms}$ & ${num}$ & ${runtime}$ & ${states}$ & ${edges}$ \\\\"))
}

