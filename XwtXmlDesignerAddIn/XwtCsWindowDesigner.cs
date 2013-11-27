//
// XwtCsWindowDesigner.cs
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
using MonoDevelop.Ide.Templates;
using System.IO;
using MonoDevelop.Projects;

namespace XwtXmlDesignerAddIn
{
    public class XwtCsWindowDesigner: SingleFileDescriptionTemplate
    {
        private string _content;
        private string _originalFileName;

        private const string template = 
            @"using System;
using Xwt;
using Xwt.Drawing;

namespace XwtXml
{{
    public partial class {0}
    {{
        public void Init() {{ }}
    }}
}}";


        public override Stream CreateFileContent(SolutionItem policyParent, Project project, string language, string fileName, string identifier)
        {
            var fn = Path.GetFileNameWithoutExtension(_originalFileName);
            _content = string.Format(template, fn);

            return base.CreateFileContent(policyParent, project, language, fileName, identifier);
        }

        public override string GetFileName (SolutionItem policyParent, Project project, string language, string baseDirectory, string entryName)
        {
            _originalFileName = base.GetFileName (policyParent, project, language, baseDirectory, entryName);
            return Path.Combine (Path.GetDirectoryName (_originalFileName), Path.GetFileNameWithoutExtension(_originalFileName) + ".designer.cs");
        }

        /// <summary>
        /// Creates content for new entity set file.
        /// </summary>
        /// <param name="language">
        /// Programming language. Omitted in implementation. <see cref="System.String"/>
        /// </param>
        /// <returns>
        /// File content. <see cref="System.String"/>
        /// </returns>
        public override string CreateContent(string language)
        {
            return _content;
        }
    }
}

