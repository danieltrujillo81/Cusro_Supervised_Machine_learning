dataset <- function (kernel, table, tmp_src, init_file) 
{

    lib<-function(start)
    {
             ds1<-read.csv(file = start, header=TRUE, sep=",")                        
             innerf <- function(text) assign("library", text, envir = .GlobalEnv)
             text <- paste(cat(sprintf('%s', ds1$location)))
             innerf(ds1$location)
    }

    loc<-function()
    {
             text<-paste0(as.character(library),"\\", as.character("object.csv"))
             assign("object", paste0(text), envir = .GlobalEnv)
             text<-paste0(as.character(library),"\\", as.character("property.csv"))
             assign("property", paste0(text), envir = .GlobalEnv)
    }

    create_ds<-function(table, tmp_src)
    {

            fn <- tmp_src 
            if (file.exists(fn)) 
                file.remove(fn)
     
            columns <- vector()
            types <- vector()

            type <- "integer()"
            ds1<-read.csv(file = property, header=TRUE, sep=",")
            for (i in 1:nrow(ds1)) 
            {
                if (all(trimws(table) == ds1$table[i]) ) 
                {
                    if (all("C" == ds1$type[i])) type <- "character()"
                    columns <- c(columns, paste0(ds1$column[i], sep = " ", collapse = NULL))
                    types <- c(types, paste0(type, sep = " ", collapse = NULL))
                    type <- "integer()" 
                } 
                 
            }  
            sink(fn)
            text<- paste0(paste0(columns), '=', paste0(types), ',') 
            text <-paste0(text, collapse=" ")
            text <- substr(text,1,nchar(text)-1) 

            cat(sprintf('%s <- data.frame( %s )\n',  table, paste0(text) ))
            sink()
            source(fn) 
     }

     lib(init_file)   
     loc()
     create_ds(table, tmp_src)
}

dataset(kernel, "Location", "tmp_source.txt", "C:\\Users\\Samuel\\Desktop\\Downloads\\library.csv") 
   

