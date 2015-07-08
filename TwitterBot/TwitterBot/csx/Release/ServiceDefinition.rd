<?xml version="1.0" encoding="utf-8"?>
<serviceModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" name="TwitterBot" generation="1" functional="0" release="0" Id="298f9a2e-34b2-4edb-bf81-76673090f138" dslVersion="1.2.0.0" xmlns="http://schemas.microsoft.com/dsltools/RDSM">
  <groups>
    <group name="TwitterBotGroup" generation="1" functional="0" release="0">
      <settings>
        <aCS name="AsyncTwitterBot:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="">
          <maps>
            <mapMoniker name="/TwitterBot/TwitterBotGroup/MapAsyncTwitterBot:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </maps>
        </aCS>
        <aCS name="AsyncTwitterBot:StorageConnectionString" defaultValue="">
          <maps>
            <mapMoniker name="/TwitterBot/TwitterBotGroup/MapAsyncTwitterBot:StorageConnectionString" />
          </maps>
        </aCS>
        <aCS name="AsyncTwitterBotInstances" defaultValue="[1,1,1]">
          <maps>
            <mapMoniker name="/TwitterBot/TwitterBotGroup/MapAsyncTwitterBotInstances" />
          </maps>
        </aCS>
      </settings>
      <maps>
        <map name="MapAsyncTwitterBot:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" kind="Identity">
          <setting>
            <aCSMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBot/Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </setting>
        </map>
        <map name="MapAsyncTwitterBot:StorageConnectionString" kind="Identity">
          <setting>
            <aCSMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBot/StorageConnectionString" />
          </setting>
        </map>
        <map name="MapAsyncTwitterBotInstances" kind="Identity">
          <setting>
            <sCSPolicyIDMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBotInstances" />
          </setting>
        </map>
      </maps>
      <components>
        <groupHascomponents>
          <role name="AsyncTwitterBot" generation="1" functional="0" release="0" software="C:\Users\FranciscoJavier\Downloads\TwitterBot\TwitterBot\TwitterBot\csx\Release\roles\AsyncTwitterBot" entryPoint="base\x64\WaHostBootstrapper.exe" parameters="base\x64\WaWorkerHost.exe " memIndex="-1" hostingEnvironment="consoleroleadmin" hostingEnvironmentVersion="2">
            <settings>
              <aCS name="Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="" />
              <aCS name="StorageConnectionString" defaultValue="" />
              <aCS name="__ModelData" defaultValue="&lt;m role=&quot;AsyncTwitterBot&quot; xmlns=&quot;urn:azure:m:v1&quot;&gt;&lt;r name=&quot;AsyncTwitterBot&quot; /&gt;&lt;/m&gt;" />
            </settings>
            <resourcereferences>
              <resourceReference name="DiagnosticStore" defaultAmount="[4096,4096,4096]" defaultSticky="true" kind="Directory" />
              <resourceReference name="EventStore" defaultAmount="[1000,1000,1000]" defaultSticky="false" kind="LogStore" />
            </resourcereferences>
          </role>
          <sCSPolicy>
            <sCSPolicyIDMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBotInstances" />
            <sCSPolicyUpdateDomainMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBotUpgradeDomains" />
            <sCSPolicyFaultDomainMoniker name="/TwitterBot/TwitterBotGroup/AsyncTwitterBotFaultDomains" />
          </sCSPolicy>
        </groupHascomponents>
      </components>
      <sCSPolicy>
        <sCSPolicyUpdateDomain name="AsyncTwitterBotUpgradeDomains" defaultPolicy="[5,5,5]" />
        <sCSPolicyFaultDomain name="AsyncTwitterBotFaultDomains" defaultPolicy="[2,2,2]" />
        <sCSPolicyID name="AsyncTwitterBotInstances" defaultPolicy="[1,1,1]" />
      </sCSPolicy>
    </group>
  </groups>
</serviceModel>