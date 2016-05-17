# xTextEdit

PowerShell DSC Module for editing text files. The resources in this module will take care of opening and saving the specified file, keeping you focus on the logics of text manipulation.

## xTextEdit

Modifies a file as plain text. Provide the file path, encoding, test script and set script. You can refer to the file as an array of strings with `$ss` in your provided scripts.

### Example

```powershell
Configuration TextEditConfig {
    Import-DscResource -Module xTextEdit

    Node WebServer {
        xTextEdit PageTitle {
            Path = "$WebBase\loginView.jsp"
            Encoding = "utf8"
            SetScript = {
                $title = $Using:Node.PageTitle
                for ($i = 0; $i -lt $ss.Count; $i++) {
                    if ( $ss[$i] -like '*<title>*</title>*' ) {
                        $ss[$i] = "<title>${title}</title>"
                        break
                    }
                }
            }
            TestScript = {
                $title = $Using:Node.PageTitle
                $ss | foreach {
                    if ($_ -like '*<title>*</title>*') {
                        return $_ -like "*<title>${title}</title>*"
                    }
                }
            }
        }
    }
}
```

## xXmlEdit

Modifies a file in XML. Provide the file path, test script and set script. You can refer to the XmlDocument with `$x` in your provided scripts.

### Example

```powershell
Configuration TextEditConfig {
    Import-DscResource -Module xTextEdit

    Node TomcatServer {
        Archive Tomcat {
            Destination = "C:\"
            Path = $InstallSource + "\apache-tomcat-${TomcatVersion}-windows-x64.zip"
        }

        xXmlEdit SSLServer {
            Path = "$CatalinaBase\conf\server.xml"
            SetScript = {
                $sslConnectorComment = $x.SelectNodes(
                    '/Server/Service/comment()[contains(., ''Connector port="8443"'')]')[0]
                $tempNode = $x.CreateElement("temp")
                $tempNode.InnerXml = $sslConnectorComment.InnerText
                $sslConnector = $tempNode.'Connector'
                $x.'Server'.'Service'.ReplaceChild($sslConnector, $sslConnectorComment)
            }
            TestScript = {
                $sslConnectors = $x.SelectNodes('/Server/Service/Connector[@port="8443"]')
                return $sslConnectors.Count -gt 0
            }
            DependsOn = @("[Archive]Tomcat")
        }
    }
}
```
