tcl;
mql trigger off;
eval {
	#Set escape mode
	set sEscapeMode [mql print escape]
	if {[string match "Escape*on" $sEscapeMode] == 1 } {
		mql set escape off
	}
   #KYB Start - User can specify his/her own location for Logs to be generated during execution
   set sOS [string tolower $tcl_platform(os)];
   set sSuffix [clock format [clock seconds] -format "%Y%m%d"]
   set userExtractionPath [ mql get env SPINNEREXTRACTIONPATH ]
   
   if { $userExtractionPath != "" } {
      if {[file exists $userExtractionPath] == 0} {
			#puts "NOTICE - Extraction path is not valid, extraction will take place at default location."
			if { [string tolower [string range $sOS 0 5]] == "window" } {
				set sSpinnerPath "c:/temp/SpinnerAgent$sSuffix";
            } else {
				set sSpinnerPath "/tmp/SpinnerAgent$sSuffix";
		    }
		} else {
			set sSpinnerPath $userExtractionPath
		}
   } else {
	   #puts "NOTICE - Extraction path is not set, extraction will take place at default location."
	   if { [string tolower [string range $sOS 0 5]] == "window" } {
		  set sSpinnerPath "c:/temp/SpinnerAgent$sSuffix";
	   } else {
		  set sSpinnerPath "/tmp/SpinnerAgent$sSuffix";
	   }
   }
   
   set sSpinnerSetting "emxSpinnerSettings.tcl"
   #KYB End - User can specify his/her own location for Logs to be generated during execution

	if {[catch {
		   if {[file exists "$sSpinnerPath/$sSpinnerSetting"] == 1} {	      
			 set iFileSet [open "$sSpinnerPath/$sSpinnerSetting" r]
			 eval [read $iFileSet]
			 close $iFileSet
			 set sSettingLoc "file $sSpinnerPath/$sSpinnerSetting"
		   } elseif {[mql list program $sSpinnerSetting] != ""} {	   
			 eval [mql print program $sSpinnerSetting select code dump]
			 set sSettingLoc "database program $sSpinnerSetting"
		   } else {
			 puts "ERROR:  Spinner Settings file missing.  Load emxSpinnerSettings.tcl in database or place in Spinner path"
			 exit 1
			 return
		   }
		  } sMsg] != 0} {
			   puts "\nERROR: Problem with settings file $sSpinnerSetting\n$sMsg"
			   exit 1
			   return
		  }
		  
		  set lsSetting [list sParentChild bUseAssignmentField bUseAccessField bRetainBusObject bImportOverwrite bBusObjOverwrite bBusRelOverwrite bTriggerAdd bTriggerMod bTriggerDel bTriggerChk sReplaceSymbolic sDelimiter sRangeDelim bShowModOnly bStreamLog bShowTransaction bOverlay bCompile lsSubDirSequence lsFileExtSkip rRefreshLog bAbbrCue iBusObjCommit bForeignVault bContinueOnError bChangeAttrType bPersonOverwrite bCDM bOut bResequenceStates sLogDir]
   set bSetErr FALSE	 
	
	foreach sSetting $lsSetting {
      if {[info exists "$sSetting"]} {
			if { $sSetting == "sLogDir" } { mql set env LOGDIRPATH $sLogDir }
	        } else {
         puts "ERROR:  Setting $sSetting is not defined.  Add parameter to $sSettingLoc - pull from latest emxSpinnerSettings.tcl program"
         set bSetErr TRUE
      }
   }

  #call jpo emxReadExtractSchema to set env
  set sExtractSchema [mql execute prog SpinnerReadExtractSchema]
  puts $sExtractSchema
  
   set sSchemaType [mql get env 1]
   set sSchemaName [mql get env 2]
   set sParam3 [mql get env 3]

   set bTemplate FALSE
   set bSpinner FALSE
   set bTrigger FALSE
   set bAllSchema FALSE

   if {$sSchemaName == "template"} {
      set bTemplate TRUE
      set bSpinner FALSE
      set bTrigger FALSE
      set sGTEDate ""
      set sLTEDate ""
   } else {
      if {[string trim [string tolower $sParam3]] == "trigger"} {
         set bTrigger TRUE
      }
      set sGTEDate [mql get env 4];
      if {[string trim [string tolower $sGTEDate]] == "spinner"} {
         set bSpinner TRUE
         set sGTEDate ""
         set sLTEDate ""
      } else {
         set sLTEDate [mql get env 5];
      }
   }
   
   if {$sSchemaType == "" || $sSchemaName == ""} {
      puts "\nInvoke program in this manner: \
            \n  exec prog emxExtractSchema.tcl \"SchemaType 1,...,SchemaType N\" \"SchemaName\" \"param3\" \"param4\" \"param5\" \
            \n\n   Note: wildcards are allowed for SchemaName - use * (asterisk) for all schema. \
            \n    Valid Examples: \
            \n       exec prog emxExtractSchema.tcl * * (dump all schema)\
            \n       exec prog emxExtractSchema.tcl type Part* (all types beginning with Part) \
            \n    For templates, specify template instead of name: \
            \n       exec prog emxExtractSchema.tcl * template \
            \n    To include trigger parameter bus objects, specify trigger as param3: \
            \n       exec prog emxExtractSchema.tcl type Part* trigger \
            \n    To filter by Spinner-controlled, specify spinner as param4: \
            \n       exec prog emxExtractSchema.tcl * * \"\" spinner \
            \n    To filter by from and to modified dates, specify dd,mm,yyyy in correct order as param4 and param5: \
            \n       exec prog emxExtractSchema.tcl * *  \"\" \"05/10/2009\" \"09/09/2009\""
      exit 1
      return
   }  

   set sDumpSchemaDirSchema [ file join $sSpinnerPath Business ]
   file mkdir $sDumpSchemaDirSchema
   set sDumpSchemaDirFiles [ file join $sSpinnerPath "Business/SourceFiles" ]
   file mkdir $sDumpSchemaDirFiles
   set sDumpSchemaDirAccess [ file join $sSpinnerPath "Business/Policy" ]
   file mkdir $sDumpSchemaDirAccess
   set sDumpSchemaDirRuleAccess [ file join $sSpinnerPath "Business/Rule" ]
   file mkdir $sDumpSchemaDirRuleAccess
   set sDumpSchemaDirPageFiles [file join $sSpinnerPath "Business/PageFiles" ]
   file mkdir $sDumpSchemaDirPageFiles
   set sDumpSchemaDirSystem [ file join $sSpinnerPath System ]
   file mkdir $sDumpSchemaDirSystem
   set sDumpSchemaDirSystemMap [ file join $sSpinnerPath "System/Map" ]
   file mkdir $sDumpSchemaDirSystemMap
   set sDumpSchemaDirObjects [ file join $sSpinnerPath Objects ]
   file mkdir $sDumpSchemaDirObjects
   mql set env SPINNERPATH $sSpinnerPath
   
   #KYB Start Fixed program extraction for program type as java 
   set sSpinnerSetting "emxSpinnerSettings.tcl"

   if {[catch {
	   if {[file exists "$sSpinnerPath/$sSpinnerSetting"] == 1} {
		 set iFileSet [open "$sSpinnerPath/$sSpinnerSetting" r]
		 eval [read $iFileSet]
		 close $iFileSet
		 set sSettingLoc "file $sSpinnerPath/$sSpinnerSetting"
	   } elseif {[mql list program $sSpinnerSetting] != ""} {
		 eval [mql print program $sSpinnerSetting select code dump]
		 set sSettingLoc "database program $sSpinnerSetting"
	   } else {
		 puts "ERROR:  Spinner Settings file missing.  Load emxSpinnerSettings.tcl in database or place in Spinner path"
		 exit 1
		 return
	   }
	  } sMsg] != 0} {
	   puts "\nERROR: Problem with settings file $sSpinnerSetting\n$sMsg"
	   exit 1
	   return
	}
   
   if {$bSetErr} {
      exit 1
      return
   }
    
   set lsSchema [list \
      program \
      role \
      group \
      person \
      association \
      attribute \
      type \
      relationship \
      format \
      policy \
      command \
      inquiry \
      menu \
      table \
      webform \
      channel \
      portal \
      rule \
      interface \
      expression \
      page \
      dimension \
      site \
      location \
      store \
      server \
      vault \
      index \
	  package \
   ]

# Short Name Array and Generate List Array
   foreach sSchema $lsSchema {
      set sShortSchema [string range $sSchema 0 3]
      set aSchema($sSchema) $sShortSchema
      set bSchema($sSchema) FALSE
   }

   set sMxVersion [mql get env DSOVERSION]
   if {[string first "V6" $sMxVersion] >= 0} {
      set rAppend ""
	  if {[string range $sMxVersion 7 7] == "x"} {set rAppend ".1"}
      set sMxVersion [string range $sMxVersion 3 6]
	  if {$rAppend != ""} {append sMxVersion $rAppend}
   } else {
      set sMxVersion [join [lrange [split $sMxVersion .] 0 1] .]
   }
   mql set env MXVERSION $sMxVersion
   
   if {$sSchemaType == "*"} {
		set lsSkipSchemaElements [list ]
 		
		foreach slsSchemaSkip $lsSkipSchemaExtraction {
			set sSkipSchemaElement [string tolower [string trim $slsSchemaSkip]]
			lappend lsSkipSchemaElements "$sSkipSchemaElement"
		}
		
      foreach sSchema $lsSchema {
			if {$sSchema != "" && [lsearch $lsSkipSchemaElements $sSchema] < 0} {
				set bSchema($sSchema) TRUE
			}
      }
      if {$sSchemaName == "*"} {
         set bTrigger TRUE
         set bAllSchema TRUE
      }
   } else {
      set lsType [split $sSchemaType ,]
      foreach sType $lsType {
         set sType [string tolower [string trim $sType]]
         set bFlag FALSE
         foreach sSchema $lsSchema {
            if {[string range $sType 0 3] == $aSchema($sSchema)} {
               set bSchema($sSchema) TRUE
               set bFlag TRUE
               break
            } 
         }
         if {!$bFlag} {
            puts "ERROR: Schema type $sType is invalid.  Valid schema types are:\n [join $lsSchema , ]"
            exit 1
            return
         }   
      }
   }
   
   # Set up arrays for symbolic name mapping
   set lsPropertyName [list ]
   set lsPropertyTo [list ]
   if {[mql list program "eServiceSchemaVariableMapping.tcl"] != ""} {
      set lsPropertyName [split [mql print program eServiceSchemaVariableMapping.tcl select property.name dump |] |]
      set lsPropertyTo [split [mql print program eServiceSchemaVariableMapping.tcl select property.to dump |] |]
   }
   mql set env PROPERTYNAME $lsPropertyName
   mql set env PROPERTYTO $lsPropertyTo
   
	set sAppend ""
	if {$sSchemaName != ""} {
		regsub -all "\134\052" $sSchemaName "ALL" sAppend
		regsub -all "\134\174" $sAppend "-" sAppend
		regsub -all "/" $sAppend "-" sAppend
		regsub -all ":" $sAppend "-" sAppend
		regsub -all "<" $sAppend "-" sAppend
		regsub -all ">" $sAppend "-" sAppend
		regsub -all " " $sAppend "" sAppend
		set sAppend "_$sAppend"
	}
	mql set env sAppend $sAppend
	mql set env lsSkipSchemaExtraction $lsSkipSchemaExtraction
	set sExtractSchema [mql execute prog SpinnerExtract]
  
  if {[string match "Escape*on" $sEscapeMode] == 1 } {
		mql set escape on
  }
}
#KYB Fixed SCR-0007291 - After running the emxExtractSchema.tcl program triggers are left turned off.
mql trigger on;
