

program split_pii
	syntax varlist , id(string) newid1(name) newid2(name) newname(string) [replace  dir(string)]
	
	isid `id'
	
	tempvar sorter1
	gen `sorter1' = runiform()
	sort `sorter1'
	drop `sorter1'
	gen `newid1' = _n

	tempvar sorter2
	gen `sorter2' = runiform()
	sort `sorter2'
	drop `sorter2'
	gen `newid2' = _n
	
	order `id' `newid1' `newid2' , first
	
	preserve
	keep `newid1' `varlist' 
	if `"`dir'"'!="" save `"`dir'/`newname'_PII.dta"' , `replace'
	else save `"`newname'_PII.dta"' , `replace'
	restore
	
	preserve
	drop `id' `newid1' `varlist' 
	if `"`dir'"'!="" save `"`dir'/`newname'_Anonymized.dta"' , `replace'
	else save `"`newname'_Anonymized.dta"' , `replace'
	restore

	preserve
	keep `id' `newid1' `newid2'
	if `"`dir'"'!="" save `"`dir'/`newname'_IDLink.dta"' , `replace'
	else save `"`newname'_IDLink.dta"' , `replace'
	restore	
	
	di as result "Dataset was de-identified and saved as three new files: dataname_PII, dataname_Anonymized, dataname_IDLink"
	di as result "Be sure to secure the original dataset."
	di as result "It is important to consider other combinations of variables that can serve as PII, as well."
	
	di in red "Did you remove all PII variables? Consider these 18 categories, mandated by HIPAA:" ///
		_newline(1) "names" ///
		_newline(1) "phone number" ///
		_newline(1) "etc"
 
end
	
	*Generates three new datasets: PII, data, and links
	*The data should have a randomly generated ID
	*Can built in options for variable lists for each of the 18 categories of
	*PHI in HIPAA? Put this in the help file.
	
	*varlist is the list of PII variables to remove.
	*id1 is the ID variable to be generated for the PII dataset
	*id2 is the ID variable to be generated for the anonymized dataset
	*dir() is optional and specifies the directory to save the new files. Defaults to 
		*working directory
	*newname() specifies the name of the (3) new files to be saved, before the suffixes.
		*For example, newname("my baseline data") would save:
			*my baseline data_PII.dta 
			*my baseline data_Anonymized.dta
			*my baseline data_IDLink.dta
	
	
	/*
	newname_PII.dta
	newname_Anonymized.dta
	newname_IDLink.dta
	OR
	data_PII.dta
	data_Anonymized.dta
	data_IDLink.dta
	*/
	
	*Warning!! You should encrypt or delete the original dataset after running this
	*command.





