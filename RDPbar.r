#!/usr/bin/env Rscript 

library (ggplot2)
library(optparse)


# set parameter
option_list <- list(
					make_option(c("-m", "--mapping"), type = "character", help = "\tinput sample mapping file\n"),
					make_option(c("-n", "--name"),    type = "character", help = "\toutput file name\n"),
					make_option(c("-e", "--element"), type = "character", default = NULL, help = "\tthe unique element in the group (column) for reorder\n" ),
					make_option(c("-l", "--label"), type = "character", default = "Smpl", help = "\tchange the x axis lavel name\n"),
					make_option(c("-g", "--group"),   type = "character", help = "\tthe column name you want to group\n"),
					make_option(c("-o", "--output"),  type = "character", default = NULL, help = "output name\n" ),
					make_option(c("-H", "--height"),  type = "numeric", default = 20, help = "plot height; default = 80\n" ),
					make_option(c("-W", "--width"),  type = "numeric", default = 80, help = "plot width; default = 20\n" )
)
custom_usage <- "\n\tRDPbar.r -m [sample mapping file] -n [output file name] -e [column element] -g [column nema] <species file>"
parser    <- OptionParser(option_list = option_list, usage = custom_usage)
arguments <- parse_args(parser, positional_argument = 1)
opt       <- arguments$options
file      <- arguments$args

# load file 					
data <- read.csv(file, sep = "\t",header = T)
mapping = read.csv(opt$mapping, sep = "\t", header = T)

# merge data by "Smpl"
df <- merge(data, mapping, by = "Smpl")


# change level
if (!is.null(opt$element)) {
	el       <- unlist(strsplit(opt$element,split = ",", fixed=T))
	df$level <- factor(df[,opt$group], levels = el)
	df$Smpl  <- as.factor(df$Smpl)	
} else {
	auto     <- unique(df[,opt$group])
	df$level <- factor(df[,opt$group], levels = auto)
	df$Smpl  <- factor(df$Smpl)
}

# color pallete
#mypalatte = c("#CCCCCC", # gray for other
mypalatte = c(
			  "#A6CEE3","#FF7F00","#09519C","#FFFB33","#556b2f",
			  "#FF00FF","#377EB8","#bb8fce","#666666","#90EE90",
			  "#fb3c4a","#A6761D","#E67E22","#323695","#E81E32",
			  "#006837","#CBC3E3","#F1C40F","#3498DB","#34495E",
			  "#FA9399","#48C9B0","#7D3C98","#ff4500","#8b4513",
			  "#8a2be2","#f0e68c","#00ffff","#32CD32","#b03060") #"#ff4500"  "#556b2f"  "#32CD32"

# reorder ( make sure "others" on the top )
lv <- levels(reorder(df$species,df$count))
lv <- c("others", lv[lv != "others"])
df$species <- factor(df$species, levels = lv)

# plot
ggplot(df, aes(x = !!as.name(opt$label), y = count, fill = species)) + # For amoA nee to change x= new_ID
geom_bar(stat = "identity", width = 0.5, alpha = 0.85) + 
scale_x_discrete(guide = guide_axis(check.overlap = F)) +
scale_y_continuous(expand = c(0,0), limits = c(0,101))+  # set bar start from y = 0 
scale_fill_manual(values = mypalatte)+
xlab("Sample") + ylab("Percentage (%)") + labs(fill = opt$name) + 
facet_grid( ~ level,space = "free_x", scales="free_x") +  # grouping 
theme_bw() +
theme(
	  text = element_text(size = 25),         # amoA size is 15  
	  strip.placement = "outside",			 # "outside"
	  strip.text.x = element_blank(),        # dont show text on top  
	  strip.background.x=element_rect(color = NA, fill= "gray"),
	  panel.grid.major = element_blank(), 
	  panel.grid.minor = element_blank(),    # remove borders 
	  panel.border = element_blank(),        # removing borders also removes x and y axes. Add them back
	  axis.line = element_line(),    
	  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1 ), 
	  legend.key.size = unit(3, 'mm'),		 # legend size 
	  panel.spacing = unit(1, "lines"),
	  ) +
guides(fill=guide_legend(keywidth = 1, keyheight = 1,ncol =1))

if (!is.null(opt$output)) { 
	ggsave(paste0(opt$output,".png"), width = opt$width, height = opt$height, limitsize = FALSE) 
} else {
	ggsave(paste0(opt$name,".png"), width = opt$width, height = opt$height, limitsize = FALSE)
}

