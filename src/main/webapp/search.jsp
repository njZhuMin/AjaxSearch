<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Search</title>
        <style type="text/css">
            #search {
                position: absolute;
                left: 50%;
                top: 50%;
                margin-left: -200px;
                margin-top: -50px;
            }

            .mouseOver {
                background: #708090;
                color: #FFFAFA;
            }

            .mouseOut {
                background: #FFFAFA;
                color: #000000;
            }
        </style>
        
        <script type="text/javascript">
            var xmlHttp;
            // get related content info
            function getMoreContents() {
                // get input keyword
                var content = document.getElementById("keyword");
                if(content.value == "") {
                    clearContent();
                    return;
                }
                // send keyword back to server via XmlHttp
                xmlHttp = getXmlHttp();
                var url = "search?keyword=" + escape(content.value);
                // true: continue without waiting for response
                xmlHttp.open("GET", url, true);
                // bind callback function, triggered by status change of xmlHttp
                // xmlHttp status: 0-4, 4: complete
                xmlHttp.onreadystatechange = callback;
                // params already in url with GET method
                xmlHttp.send(null);
            }

            function getXmlHttp() {
                var xmlHttp;
                // for most browser
                if(window.XMLHttpRequest)
                    xmlHttp = new XMLHttpRequest();
                // IE compatibility
                if(Window.ActiveXObject) {
                    xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                    if(!xmlHttp)
                        xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
                }
                return xmlHttp;
            }
            
            function callback() {
                if(xmlHttp.readyState == 4) {
                    if (xmlHttp.status == 200) {
                        var result = xmlHttp.responseText;
                        // parse JSON
                        var json = eval("(" + result + ")");
                        // display to DOM
                        setContent(json);
                    }
                }
            }

            // display content to DOM
            function setContent(contents) {
                // clear content first
                clearContent();
                // set div position
                setLocation();
                var size = contents.length;
                if(size == 0) {
                    clearContent();
                    return;
                }

                for(var i = 0; i < size; i++) {
                    var nextNode = contents[i];
                    var tr = document.createElement("tr");
                    var td = document.createElement("td");
                    td.setAttribute("border", "0");
                    td.setAttribute("bgcolor", "#FFFAFA");
                    td.onmouseover = function () {
                        this.className = "mouseOver";
                    };
                    td.onmouseout = function () {
                        this.className = "mouseOut";
                    };
                    td.onmousedown = function () {
                        document.getElementById("keyword").value = this.innerText;
                    };

                    var text = document.createTextNode(nextNode);
                    td.appendChild(text);
                    tr.appendChild(td);
                    document.getElementById("content_table_body").appendChild(tr);
                }
            }

            function clearContent() {
                var contentTableBody = document.getElementById("content_table_body");
                var size = contentTableBody.childNodes.length;
                for(var i = size - 1; i >= 0; i--)
                    contentTableBody.removeChild(contentTableBody.childNodes[i]);
                document.getElementById("popDiv").style.border = "none";
            }

            // when input box loses focus
            function keywordBlur() {
                clearContent();
            }
            
            function setLocation() {
                var content = document.getElementById("keyword");
                // width of input box
                var width = content.offsetWidth;
                var left = content["offsetLeft"];
                var top = content["offsetTop"] + content.offsetHeight;
                // get display div
                var popDiv = document.getElementById("popDiv");
                popDiv.style.border = "black 1px solid";
                popDiv.style.left = left + "px";
                popDiv.style.top = top + "px";
                popDiv.style.width = width + "px";
                document.getElementById("content_table").style.width = width + "px";
            }
        </script>
    </head>
    <body>
        <div id="search">
            <!-- input box -->
            <input type="text" size="50" id="keyword" onkeyup="getMoreContents()"
                onblur="keywordBlur()" onfocus="getMoreContents()"/>
            <input type="button" value="Search" width="50px" />
            <!-- display content below -->
            <div id="popDiv">
                <table id="content_table" bgcolor="#FFFAFA" border="0"
                       cellspacing="0" cellpadding="0">
                    <tbody id="content_table_body">

                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
