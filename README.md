# xTextEdit

PowerShell DSC Module for editing text files.

## xXmlEdit

Modifies a file in XML. Provide the file path, test script and set script, and leave the open and save chores to this resource. You can refer to the XmlDocument with `$x` in your provided scripts. 

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
