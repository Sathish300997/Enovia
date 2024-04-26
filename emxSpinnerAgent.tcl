tcl;
mql trigger off;
eval {
#Set escape mode
   set sEscapeMode [mql print escape]
   if {[string match "Escape*on" $sEscapeMode] == 1 } {
		mql set escape off 
   }
  # Read arguments 
   set sSpinnerPath [mql get env 1]
 
   set sArg1 [string tolower $sSpinnerPath]   
   set sSpinnerSetting [mql get env 2]
  
   set sArg2 [string tolower $sSpinnerSetting]
   set sArg3 [string tolower [mql get env 3]]
   set sArg4 [string tolower [mql get env 4]]
   set bScan FALSE
   set bReset FALSE   
   set bMQLExtract FALSE
   set bXMLExtract FALSE
    
   if {$sArg3 == "scan"} {
      set bScan TRUE
   } elseif {$sArg3 == "reset" || $sArg3 == "force"} {
      set bReset TRUE
   } elseif {$sArg2 == "scan"} {
      set bScan TRUE
      set sSpinnerSetting ""
   } elseif {$sArg2 == "reset" || $sArg2 == "force"} {
      set bReset TRUE
      set sSpinnerSetting ""
   } elseif {$sArg1 == "scan"} {
      set bScan TRUE
      set sSpinnerPath ""
      set sSpinnerSetting ""
   } elseif {$sArg1 == "reset" || $sArg1 == "force"} {
      set bReset TRUE
      set sSpinnerPath ""
      set sSpinnerSetting ""
   }
   
   if { $sArg1 == "mql" || $sArg2 == "mql" || $sArg3 == "mql" || $sArg4 == "mql" } {
	 set sSpinnerPath ""
	 set sSpinnerSetting ""
	 mql set env VALIDATEMQLLIC TRUE
   }
   #call jpo emxReadSpinnerAgent to set env
   set sAgent [mql execute prog emxReadSpinnerAgent]
   puts $sAgent
   
   if { $sArg1 == "mql" || $sArg2 == "mql" || $sArg3 == "mql" || $sArg4 == "mql" } {		
		set bExtract [mql get env SPINNEREXTRACT]	
		if { $bExtract == "MQL" || $bExtract == "mql" || $bExtract == "BOTH" || $bExtract == "both" } {
			set bMQLExtract TRUE
		} else {		
            puts "\nERROR: MQL Extract is not supported by license."
		    exit 1
		    return
		}
   }
   
   if { $sArg1 == "xml" || $sArg2 == "xml" || $sArg3 == "xml" || $sArg4 == "xml" } {		
		set bExtract [mql get env SPINNEREXTRACT]
		if { $bExtract == "XML" || $bExtract == "xml" || $bExtract == "BOTH" || $bExtract == "both" } {
			set bXMLExtract TRUE
		} else {		
            puts "\nERROR: XML Extract is not supported by license."
			exit 1
			return
		}
   }
   
   if { $sArg1 == "both" || $sArg2 == "both" || $sArg3 == "both" || $sArg4 == "both" } {		
		set bExtract [mql get env SPINNEREXTRACT]		
		if { $bExtract == "BOTH" || $bExtract == "both" } {
			set bXMLExtract TRUE
			set bMQLExtract TRUE
		} else {		
            puts "\nERROR: Extract for BOTH(MQL & XML) is not supported by license."
			exit 1
			return
		}
   }

    if { $sArg1 == "mql|xml" || $sArg2 == "mql|xml" || $sArg3 == "mql|xml" || $sArg4 == "mql|xml" || $sArg1 == "xml|mql" || $sArg2 == "xml|mql" || $sArg3 == "xml|mql" || $sArg4 == "xml|mql" } {		
		set bExtract [mql get env SPINNEREXTRACT]
		
		if { $bExtract == "BOTH" || $bExtract == "both" } {
			set bXMLExtract TRUE
			set bMQLExtract TRUE
		} else { 
			puts "\nERROR: Extract for BOTH(MQL & XML) is not supported by license."
		}
		
		if { $bXMLExtract != "TRUE" } {
			if { ( $bExtract == "XML" || $bExtract == "xml" ) } {
			set bXMLExtract TRUE
		} else { 
            puts "\nERROR: XML Extract is not supported by license."
		}
		
		}
		if { $bMQLExtract != "TRUE" } {			
			if { ( $bExtract == "MQL" || $bExtract == "mql" ) } {
			set bMQLExtract TRUE
		} else { 
            puts "\nERROR: MQL Extract is not supported by license."
			}
		}
			
		if { ( $bMQLExtract != "TRUE ") && ( $bXMLExtract != "TRUE" ) } {
			puts "\nERROR: Extract for BOTH (mql|xml) is not supported by license."
			exit 1
			return
		}
   }
   
   if {$bScan} {mql set env SPINNERSCANMODE TRUE}
   if {$bMQLExtract} {mql set env SPINNEEXTRACTMQL TRUE}
   if {$bXMLExtract} {mql set env SPINNEEXTRACTXML TRUE}   
   if { $sSpinnerPath != "" } { 
		set sImportPath $sSpinnerPath
   } else {
		set sImportPath [pwd] 
   }
   #set sImportPath [pwd] 
# Read settings
   if {$sSpinnerSetting == ""} {set sSpinnerSetting emxSpinnerSettings.tcl}
   if {[catch {
      if {[file exists "$sImportPath/$sSpinnerSetting"] == 1} {
         set iFileSet [open "$sImportPath/$sSpinnerSetting" r]
         eval [read $iFileSet]
         close $iFileSet
         set sSettingLoc "file $sImportPath/$sSpinnerSetting"
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

   set lsSetting [list sParentChild bUseAssignmentField bUseAccessField bRetainBusObject bImportOverwrite bBusObjOverwrite bBusRelOverwrite bTriggerAdd bTriggerMod bTriggerDel bTriggerChk sReplaceSymbolic sDelimiter sRangeDelim bShowModOnly bStreamLog bShowTransaction bOverlay bCompile lsSubDirSequence lsFileExtSkip rRefreshLog bAbbrCue iBusObjCommit bForeignVault bContinueOnError bChangeAttrType bPersonOverwrite bCDM bOut bResequenceStates sLogDir bSpinnerRollBack sGlobalConfigType sTransactionMode]
   set bSetErr FALSE   
   foreach sSetting $lsSetting {
      if {[info exists "$sSetting"]} {
		if { $sSetting == "sLogDir" } { mql set env LOGDIRPATH $sLogDir }
      } else {
         puts "ERROR:  Setting $sSetting is not defined.  Add parameter to $sSettingLoc - pull from latest emxSpinnerSettings.tcl program"
         set bSetErr TRUE
      }
   }
   if {$bSetErr} {
      exit 1
      return
   }
  # if { $bJavaImport } { 
    
   #set sImportPath [pwd] 
   mql execute prog emxSpinnerImport $sImportPath $bScan $bReset $bMQLExtract $bXMLExtract
 # } else {
	  #call jpo emxReadSpinnerAgent to set env
	  #set sAgent [mql execute prog emxReadSpinnerAgent]
	  #puts $sAgent
	  
	  #get env SpinnerAgent
	  #set sEvalAgent [mql get env SpinnerAgent]
	  #eval  $sEvalAgent 
  #}
  if {[string match "Escape*on" $sEscapeMode] == 1 } {
		mql set escape on
  }
}
#KYB Fixed SCR-0007291 - After running the emxExtractSchema.tcl program triggers are left turned off.
mql trigger on;