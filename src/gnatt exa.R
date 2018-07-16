library(plotly)

# Read in data
df <- read.csv("https://cdn.rawgit.com/plotly/datasets/master/GanttChart-updated.csv", stringsAsFactors = F)

# Convert to dates
df$Start <- as.Date(df$Start, format = "%m/%d/%Y")

# Sample client name
client = "Sample Client"

# Choose colors based on number of resources
cols <- RColorBrewer::brewer.pal(length(unique(df$Resource)), name = "Set3")
df$color <- factor(df$Resource, labels = cols)

# Initialize empty plot
p <- plot_ly()

# Each task is a separate trace
# Each trace is essentially a thick line plot
# x-axis ticks are dates and handled automatically

for(i in 1:nrow(df)){
  p <- add_trace(p,
                 x = c(df$Start[i], df$Start[i] + df$Duration[i]),  # x0, x1
                 y = c(i, i),  # y0, y1
                 mode = "lines",
                 line = list(color = df$color[i], width = 20),
                 showlegend = F,
                 hoverinfo = "text",
                 
                 # Create custom hover text
                 
                 text = paste("Task: ", df$Task[i], "<br>",
                              "Duration: ", df$Duration[i], "days<br>",
                              "Resource: ", df$Resource[i]),
                 
                 evaluate = T  # needed to avoid lazy loading
  )
}
