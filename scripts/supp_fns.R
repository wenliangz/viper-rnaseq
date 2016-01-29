######Some supplemental fns that are used by heatmap_plot*.R and cluster_plot.R
#BASED on heatmap_supp_funcs.R written by Henry Long

zscore = function(x){
    y=(x-mean(x))/sd(x)
    return(y)
}

cmap <- function(x, use_viridis=FALSE) {
    colors = c("#3182bd", "#e6550d", "#31a354", "#756bb1", "#636363", "#BD4931", "#6baed6", "#fd8d3c", "#74c476", "#9e9ac8", "#969696", "#D67D6B", "#9ecae1", "#fdae6b", "#a1d99b", "#bcbddc", "#bdbdbd", "#E0A89D", "#c6dbef", "#fdd0a2", "#c7e9c0", "#dadaeb", "#d9d9d9", "#F0CEC7")
    
    x <- sort(unique(na.omit(as.vector(x))))
    if(use_viridis) {
        col <- viridis(length(x))
    } else {
        col <- colors[1:length(x)]
    }
    
    names(col) <- x
    return(col)
}

make_complexHeatmap_annotation <- function(ht_list, annotation){
    MIN_UNIQUE <- 6
    global_gp = gpar(fontsize = 8)
    title_gp = gpar(fontsize = 8, fontface = "bold")

    for(c in colnames(annotation)) {
        ann <- as.matrix(annotation[, c])
        if(length(sort(unique(na.omit(as.vector(ann))))) < MIN_UNIQUE) {
            col <- cmap(ann)
        } else {
            col <- colorRamp2(seq(min(ann, na.rm = TRUE), max(ann, na.rm = TRUE), length = 3), c("blue","white","red"))
        }
        jj<- NULL
        
        ht_list <- ht_list + Heatmap(
            ann,
            na_col = "black",
            name = gsub("_", " ", c),
            col = col,
            width = unit(3, "mm"),
            column_names_gp = global_gp,
            column_title_gp = global_gp
        #   heatmap_legend_param = list(title_gp = title_gp, labels_gp = global_gp)
            )
    }
    return(ht_list)
}

#NOTE: LEN removed the threeD code
make_pca_plots = function(data_matrix, threeD = TRUE, labels = TRUE, pca_title = "Data Matrix", legend_title = "", ClassColorings) {

    #Standard PCA analysis
    pca_out <- prcomp(data_matrix, scale. = TRUE, tol = 0.05)
    pc_var <- signif(100.0 * summary(pca_out)[[6]][2,1:3], digits = 3)

    plot(pca_out$x[,"PC1"], pca_out$x[,"PC2"],  col=ClassColorings, pch=16, xlab=paste0("PC1 (", pc_var[1], "% of variance)"), ylab=paste0("PC2 (", pc_var[2], "% of variance)"), main = paste0('PCA analysis of ',pca_title))
    if(labels == TRUE) {text(pca_out$x[,"PC1"], pca_out$x[,"PC2"], labels=row.names(data_matrix), cex= 0.7, pos=3)}
    if(legend_title != "") {
        mycols = unique(ClassColorings)
        mynames = unique(names(ClassColorings))
        legend("bottomright", legend = mynames, col=mycols, pch = 16, title = legend_title)
    }

#    if(threeD==TRUE){
#        #try 3D plot
#        library("rgl", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
#        pca3d<-cbind(pca_out$x[,1], pca_out$x[,2], pca_out$x[,3])
#        plot3d(pca3d, type="s",col=ClassColorings, size=1, scale=0.2)
#    }

    return(pca_out)
}
######END SUPPLEMENTAL Fns #######