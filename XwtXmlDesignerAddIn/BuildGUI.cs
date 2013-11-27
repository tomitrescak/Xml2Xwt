//
// BuildGUI.cs
//
// Author:
//       Tomas Trescak <tomi.trescak@gmail.com>
//
// Copyright (c) 2013 (C) 2013 Tomas Trescak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
using System;
using MonoDevelop.Components.Commands;
using MonoDevelop.Ide;
using Mono.TextEditor;
using System.IO;
using System.Xml.XPath;
using System.Xml;
using System.Reflection;
using System.Xml.Xsl;
using Gtk;

namespace XwtXmlDesignerAddIn
{
    public class BuildGUI : CommandHandler
    {
        string _fileName;

        protected override void Run ()  
        {  
            try {
                XPathDocument myXPathDoc = new XPathDocument(_fileName) ;


                // load from resource

                XslCompiledTransform myXslTrans = new XslCompiledTransform();

                //XmlReader xsltReader = XmlReader.Create(Assembly.GetExecutingAssembly().GetManifestResourceStream("XwtXmlDesignerAddIn.Resources.Xml2Xwt.xslt"));
                //myXslTrans.Load(xsltReader);
                myXslTrans.Load(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Resources", "Xml2Xwt.xslt"));

                // delete previously existing file
                var path = Path.Combine (Path.GetDirectoryName (_fileName), Path.GetFileNameWithoutExtension (_fileName) + ".cs");

                // first clear contents of the file (we do it like this so that MD registers the change)
                using (var stream = File.Open(path, FileMode.Open)) {
                    stream.SetLength(0);
                    stream.Close();
                }

                using (var stream = File.Open(path, FileMode.Open)) {
                    XmlTextWriter myWriter = new XmlTextWriter(stream, null);
                    myXslTrans.Transform(myXPathDoc, null, myWriter);
                }

                MessageDialog md = new MessageDialog (IdeApp.Workbench.RootWindow, DialogFlags.Modal, MessageType.Info, ButtonsType.Ok, "Successfully generated!");
                md.Run ();
                md.Destroy();

            } catch (Exception ex) {
                MessageDialog md = new MessageDialog (IdeApp.Workbench.RootWindow, DialogFlags.Modal, MessageType.Error, ButtonsType.Ok, "Error generating GUI: " + ex.Message);
                md.Run ();
                md.Destroy();
            }
        }  

        protected override void Update (CommandInfo info)  
        {  

            MonoDevelop.Ide.Gui.Document doc = IdeApp.Workbench.ActiveDocument;  
            _fileName = doc.FileName;
            info.Enabled = doc != null && Path.GetExtension (doc.FileName) == ".xml";
        }    
    }
}

