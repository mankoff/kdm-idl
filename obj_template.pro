; $Id: //depot/idl/IDL_64/idldir/examples/obj_template.pro#1 $
;
; Copyright (c) 1997-2007, ITT Visual Information Solutions. All
;       rights reserved.
;+
; CLASS_NAME:
;	ClassName
;
; PURPOSE:
;	Describe your object class does here.  I like to start with the words:
;	"A <whatever> object ..."
;	Try to use the active, present tense.
;
; CATEGORY:
;	Put a category (or categories) here.  For example:
;	Graphics
;
; SUPERCLASSES:
;       List classes this class inherits from.
;
; SUBCLASSES:
;       List classes that inherit from this class, if any.
;
; CREATION:
;       Note how an object of this class is created.
;       Generally, this is just a reference to the class'
;       Init method.
;
; METHODS:
;       List the methods intrinsic to this class. There is no
;       need to list the inherited methods.
;
; MODIFICATION HISTORY:
; 	Written by:	Your name here, Date.
;	June, 1997	Any additional mods get described here.  Remember to
;			change the stuff above if you add a new keyword or
;			something!
;
; =============================================================
; Include a section for each method...
; =============================================================
;
; METHODNAME:
;       ClassName::MethodName
;
; PURPOSE:
;       Describe what the method does. Note whether the method is
;       a lifecycle method for the class.
;
; CALLING SEQUENCE:
;	Write the calling sequence here. Include only positional parameters
;	(i.e., NO KEYWORDS). For procedure methods, use the form:
;
;	Obj -> [Class_name::]MethodName, Parameter1, Parameter2, Foobar
;
;	For functions, use the form:
; 
;	Result = Obj -> [Class_name::]MethodName(Parameter1, Parameter2, Foobar)
;
;	Always use the "Result = " part to begin. This makes it super-obvious
;	to the user that this routine is a function!
;
;       If the method is a lifecycle method, include the
;
;       Obj = OBJ_NEW('ClassName', Parameter1, Parameter2)
;         or
;       OBJ_DESTROY, Obj
;
;       syntax along with the method-call syntax.
;
;
; INPUTS:
;	Parm1:	Describe the positional input parameters here. Note again
;		that positional parameters are shown with Initial Caps.
;
; OPTIONAL INPUTS:
;	Parm2:	Describe optional inputs here. If you don't have any, just
;		delete this section.
;	
; KEYWORD PARAMETERS:
;	KEY1:	Document keyword parameters like this. Note that the keyword
;		is shown in ALL CAPS!
;
;	KEY2:	Yet another keyword. Try to use the active, present tense
;		when describing your keywords.  For example, if this keyword
;		is just a set or unset flag, say something like:
;		"Set this keyword to use foobar subfloatation. The default
;		 is foobar superfloatation."
;
; OUTPUTS:
;	Describe any outputs here.  For example, "This function returns the
;	foobar superflimpt version of the input array."  This is where you
;	should also document the return value for functions.
;
; OPTIONAL OUTPUTS:
;	Describe optional outputs here.  If the routine doesn't have any, 
;	just delete this section.
;
; COMMON BLOCKS:
;	BLOCK1:	Describe any common blocks here. If there are no COMMON
;		blocks, just delete this entry. Object methods probably
;               won't be using COMMON blocks.
;
; SIDE EFFECTS:
;	Describe "side effects" here.  There aren't any?  Well, just delete
;	this entry.
;
; RESTRICTIONS:
;	Describe any "restrictions" here.  Delete this section if there are
;	no important restrictions.
;
; PROCEDURE:
;	You can describe the foobar superfloatation method being used here.
;	You might not need this section for your routine.
;
; EXAMPLE:
;	Please provide a simple example here. An example from the
;	DIALOG_PICKFILE documentation is shown below. Please try to
;	include examples that do not rely on variables or data files
;	that are not defined in the example code. Your example should
;	execute properly if typed in at the IDL command line with no
;	other preparation. 
;
;       Create a DIALOG_PICKFILE dialog that lets users select only
;       files with the extension `pro'. Use the `Select File to Read'
;       title and store the name of the selected file in the variable
;       file. Enter:
;
;       file = DIALOG_PICKFILE(/READ, FILTER = '*.pro') 
;
; MODIFICATION HISTORY:
; 	Written by:	Your name here, Date.
;	July, 1994	Any additional mods get described here.  Remember to
;			change the stuff above if you add a new keyword or
;			something!
;-

PRO TEMPLATE

  PRINT, "This is an example header file for documenting IDL object classes"

END
