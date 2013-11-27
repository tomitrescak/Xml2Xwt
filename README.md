# XWT XML Designer

1. Adds a new file template for XWT GUIs
2. Adds a new command to the build menu (Build GUI), which allows building XWT guis from XML. 

## Installation 

1. Download and compile the project in Xamarin Studio
1. Copy the output to the new directory in:
	* **Mac:**	~/Library/Application Support/XamarinStudio-4.0/LocalInstall/Addins
	* **Windows Vista/7:** ~/AppData/Local/XamarinStudio-4.0/LocalInstall/Addins
	* **Linux**: ~/.local/share/MonoDevelop-4.0/LocalInstall/Addins
1. Restart Xamarin Studio

## Usage

1. Create a new XWT application and add all references (e.g. XWT.dll, XWT.Mac.dll, monomac.dll)
1. Add a new file from our new template (Add -> New File -> XWT -> XWT Window)
1. Add-In creates three new files:
	* FileName.cs - Here you place your custom code
	* FileName.designer.cs - Here the automatically generated code is placed (*do not modify this file!*)
	* FileName.designer.xml - Here you put your design XML
1. Create your GUI in XML (see bottom of this wiki for XML example)
1. Build your GUI using the menu item "Build -> Build GUI"
1. Code will be emitted to FileName.designer.cs (you may need to re-open the file to see the changes -> see the known issues list).

## Known issues

1. Small support of all existing XWT possibilities
1. Added files (FileName.designer.cs and FileName.designer.xml) should be put as child (FileName.cs). No idea here.
1. Generated file should refresh in Xamarin - no idea here, tried almost everything
1. Generated code is fugly, with horrendous indentation and new lines.

## Developers

Project contains the "Xml2Xwt.xsl" XSLT template which is repossible for code generation. This file is a work in progress, where gradually I will be adding more and more stuff. But, I, if possible ;), as possibilities of XWT are quite large and I do not have anough time.

## Initiative

This project is more an initiative than full developed solution. I will be modifying the given XSLT file to include most of the XWT posibilities, but to make this project be done sooner and with more features, I would appreciate your help.

## XML Example ##

