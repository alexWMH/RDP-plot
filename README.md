# RDP taxonomy visualization ( Taxonomy percentage barplot)  
This package is for plotting RDP classifier result  
Also you must need:  
	`RDP classifier` result file  
	`Taxonomy table`  
	`sample mapping`/`(meta data)`    
## RDP classifier result file
Example for RDP classifier usage:  
```Bash  
java -Xmx8g -jar ~/path/to/your/classifier.jar -t ~/path/to/your/rRNAClassifier.properties -o otus.rdp -c 0.8 -f allrank otus.fa  
```  
Options:  
`-jar`: Is the path to the "classifier.jar".  
`-t`: Your self database of taxonomy.   
`-o`: Output of RDP result.  
`-c`: Confident score.  
`-f`: Taxonomy rank you want to.  
`<ARGV>`: your OTU fasta file.  

## Taxonomy table
Example for OTU table:  
| OtuID  | Sample1  | Sample2  | Sample3 | ...  |
|:-----:|:-----:|:-----:|:-----:|:-----:|
| Otu1 | 223 | 6613 | 11887 | ... |  
| Otu2 | 3032 | 10796 | 3389 | ... |   
| Otu3 | 508 | 5872 | 5390 | ...  |  
| Otu4 | 38 | 1400 | 420 | ... |  
| ... | ... | ... | ... | ... |  
  
Then you can turn OTU table to OTU frequency table by `OtuFrequency.pl`  
```Bash  
OtuFrequency.pl otutab.txt > otutab.freq
```  
The result would like this:  
| OtuID  | Sample1  | Sample2  | Sample3 | ...  |
|:-------:|:-------:|:-------:|:-------:|:-------:|
| Otu1 | 0.361 | 9.161 | 16.685 | ... |  
| Otu2 | 4.913 | 14.955 | 4.757 | ... |  
| Otu3 | 0.823 | 8.134 | 7.566 | ... |  
| Otu4 | 0.062 | 1.939 | 0.590 | ... |  
| ... | ... | ... | ... | ... |  
  
Last using `RdpTaxonomyFrequency.pl` to make Taxonomy table  
```Bash  
RdpTaxonomyFrequency.pl -z otutab.freq -r otus.rdp > oturdp.genus.freq
```  
Options:  
`-z`: input OTU frequency table.   
`-r`: input the rdp result file.  

## Sample mapping file  
Example for `sample mapping` file  
| name | group | sex |
|:-----:|:-----:|:-----:|
| Sample1 | 1 | M |
| Sample2 | 2 | M |
| Sample3 | 3 | F |
| Sample4 | 4 | F |  

Then we can starting plot the Taxonomy composition barplot!!  
Make sure the RDPBar.r is in your bin.  
```Bash  
Rdp_bar_plot.pl -s sample_mapping.txt oturdp.family.freq  
```
Options:  

`-s`: Input file : sample mapping file. -> make sure the sample mapping file sample column name change to "Smpl".  
`-g`: Select column name you want to distingush group.  
`-e`: The group unique element for reorder sepprate by ",", ex. Con,disease1,disease2,....  default is NULL.  
`-t`: Top species you want to show. default is 10, max is 30.  
`-o`: Output file name.  
`-Y`: Plot height default = 20.  
`-W`: Plot width; default = 80.  
`-h`: Show this message.  


