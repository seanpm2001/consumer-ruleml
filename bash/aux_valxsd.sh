#!/bin/bash
# dc:rights [ 'Copyright 2015 RuleML Inc. -- Licensed under the RuleML Specification License, Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://ruleml.org/licensing/RSL1.0-RuleML. Disclaimer: THIS SPECIFICATION IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, ..., EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. See the License for the specifics governing permissions and limitations under the License.' ]
# Validate an XSD schema, and optionally an XML instance of it
# Prerequisites:
#   Installation of Java, JAXB, xmllint
# Note: change the JAXB_HOME path according to your path to the JAXB library
# Dependencies:
# JAXB
# xmllint
# FIXME use configuration scripts to set path variables
JAXB_HOME=/Library/Java/JAXB/jaxb-ri-2.2.6/
# Finds the filename without extension
filename=$(basename "$1")
extension=${filename##*.}
#filenameNE=${filename%.*}

# Verifies that input schema name ends in ".xsd"
if [ "${extension}" != "xsd" ];then
   echo "Extension" "$extension"  "is not .xsd"
   exit 1
fi

# Validate schema against JAXB if there is only one argument, 
# or if the third argument is 1
if [[ "$#" -eq 1 ]] || [[ -e "$3"  &&  "$3" -eq "1" ]]; then
  echo "Validating " "$1" " with JAXB"
  java -jar "${JAXB_HOME}lib/jaxb-xjc.jar" "$1" -disableXmlSecurity -d "${TMPDIR}"  >> /dev/null 2>&1
  if [ "$?" -ne "0" ]; then
     echo "Validation Failed for schema " "$1"
     exit 1
   fi
fi    
 # Validate (using xmllint) the second argument as an instance, if the file exists  
 if [[ -e $2 ]]; then
   xmllint -noout --schema "$1" "$2"   >> /dev/null 2>&1
   if [ "$?" -ne "0" ]; then
     echo "Validation Failed for instance " "$2"
     exit 1
   fi

 fi  