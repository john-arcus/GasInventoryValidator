Feature: Validate uploaded inventory files.

In order to test to ensure uploaded spreadsheets are in the correct format
As a checker of a client's submitted data
I can run a program to test and report on the state of the files in the shared folder. 

Examples:

Scenario: Uploaded File is not a Google Sheet
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder is shared to "sally@example.com" (the client)
  And "sally@example.com" has uploaded a spreadsheet called "UploadedFileIsNotAGoogleSheet.xlsx" to the "MyInventories" folder
  And "sally@example.com" has not converted that spreadsheet to a Google Sheet
  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then he is informed that the "MyInventories" folder contains "Total files: 1, Google Sheets: 0, Non-Google Sheets: 1"


Scenario: Uploaded File is a Google Sheet
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder is shared to "sally@example.com" (the client)
  And "sally@example.com" has uploaded a spreadsheet called "UploadedFileIsAGoogleSheet" to the "MyInventories" folder
  And "sally@example.com" has converted that spreadsheet to a Google Sheet
  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then he is informed that the "MyInventories" folder contains "Total files: 1, Google Sheets: 1, Non-Google Sheets: 0"



Scenario: Google Sheet fails validation test on columns
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "GoogleSheetFailsValidationTestOnColumns"  
  And "GoogleSheetFailsValidationTestOnColumns" contains the following data:

     | foo | bar | bat |
     | x | x | x  |

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then he is informed that "GoogleSheetFailsValidationTestOnColumns" is missing columns: `Name`, `Quantity`, `Purpose`, `PurposeOther`, `KNumberExists`, `KNumber` and `AlternativeNumber`"
  And "Fail" is reported as the summary.

Scenario: Non-verbose mode passes validation test on columns with minimal details reported
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "VerbosityModesPassesValidationTestOnColumnsWithVaryingVerbosity"   
  And "VerbosityModesPassesValidationTestOnColumnsWithVaryingVerbosity" contains the following data:

     | foo | Quantity | bar | Name | Purpose | PurposeOther | KNumberExists | KNumber | AlternativeNumber | bat |
     | x | 99 | x | baz | 11 |   | true | 1111111 |  | x |

  When "jim@example.net" runs a test process on the "MyInventories" folder
  And no argument is passed to run the process in verbose mode (default is non-verbose)
  Then no 'column assertion fails' are reported.
  And "OK" is reported.

Scenario: Verbose mode passes validation test on columns with details reported
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "VerbosityModesPassesValidationTestOnColumnsWithVaryingVerbosity" 
  And "VerbosityModesPassesValidationTestOnColumnsWithVaryingVerbosity" contains the following data:

     | foo | Quantity | bar | Name | Purpose | PurposeOther | KNumberExists | KNumber | AlternativeNumber | bat |
     | x | 99 | x | baz | 11 |   | true | 1111111 |  | x |

  When "jim@example.net" runs a test process on the "MyInventories" folder
  And an argument is passed to run the process in verbose mode 
  Then the results of each 'column assertion pass' is reported.
  And other assertion passes are reported.
  And "OK" is reported as the summary.

Scenario: `KNumberExists` is true but `KNumber` empty
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "KNumberExistsIsTrueButKNumberEmpty" 
  And "KNumberExistsIsTrueButKNumberEmpty" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | true | | 99 | | 11 | | 

  When "jim@example.net" runs a test process on the "MyInventories" folder 
  Then it should be reported that "`KNumberExists` is true but `KNumber` is empty" 
  And "Fail" is reported as the summary.


Scenario: `KNumberExists` is neither `false` nor `true`
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "KNumberExistsIsNeitherFalseNorTrue" 
  And "KNumberExistsIsNeitherFalseNorTrue" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | FALSE | | 99 | foo | 11 | |

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then it should be reported that "`KNumberExists` is neither `false` nor `true` (note lowercase)" 
  And "Fail" is reported as the summary.

Scenario: `KNumberExists` is `false` but `AlternativeNumber` empty
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "KNumberExistsIsFalseButAlternativeNumberEmpty" 
  And "KNumberExistsIsFalseButAlternativeNumberEmpty" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | false | | 99 | | 11 | | 

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then it should be reported that "`KNumberExists` is false but `AlternativeNumber` is empty" 
  And "Fail" is reported as the summary.


Scenario: Purpose is `26` but PurposeOther is empty
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "PurposeIs26ButPurposeOtherIsEmpty" 
  And "PurposeIs26ButPurposeOtherIsEmpty" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | true | 1111111 | 99 | | 26 | | 

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then it should be reported that "`Purpose` is [26] but `PurposeOther` is empty" 
  And "Fail" is reported as the summary.

Scenario: `KNumber` is present but not in correct format
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "KNumberIsPresentButNotInCorrectFormat"   
  And "KNumberIsPresentButNotInCorrectFormat" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | true | 1 | 99 | | 11 | | 

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then it should be reported that "`KNumber` is present but not in correct format (7 digits)" 
  And "Fail" is reported as the summary.



Scenario: `Purpose` not in correct format
  Given there is a folder on GSuite called "MyInventories"
  And that folder is owned by "jim@example.net"
  And that folder contains a Google Sheet called "PurposeNotInCorrectFormat"   
  And "PurposeNotInCorrectFormat" contains the following data:

     | Name | KNumberExists | KNumber | Quantity | AlternativeNumber | Purpose | PurposeOther | 
     | baz | true | 1111111 | 99 | | oh | | 

  When "jim@example.net" runs a test process on the "MyInventories" folder
  Then it should be reported that "`Purpose` is not a number between 1 and 26" 
  And "Fail" is reported as the summary.
