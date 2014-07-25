# haproxy-smf-wrapper
A wrapper for running HAProxy under SMF.

This wrapper is a modified systemd wrapper from HAProxy's source tree.

## Installation
```sh
git clone https://github.com/mmalecki/haproxy-smf-wrapper.git
cd haproxy-smf-wrapper
gmake
cp haproxy-smf-wrapper /opt/local/bin
```

## Usage
Here is an example SMF manifest you would use to run HAProxy with the SMF
wrapper:

```xml
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
<service_bundle type="manifest" name="haproxy">
  <service name="site/haproxy" type="service" version="1">
    <create_default_instance enabled="false" />

    <single_instance />

    <dependency name="network" grouping="require_all" restart_on="error" type="service">
      <service_fmri value="svc:/milestone/network:default" />
    </dependency>

    <dependency name="filesystem" grouping="require_all" restart_on="error" type="service">
      <service_fmri value="svc:/system/filesystem/local" />
    </dependency>

    <method_context working_directory="/tmp">
      <method_credential user="haproxy" group="haproxy" />
    </method_context>

    <exec_method type="method" name="start" exec="/opt/local/sbin/haproxy-smf-wrapper -p /tmp/haproxy.pid -f %{config_file}" timeout_seconds="60" />
    <exec_method type="method" name="stop" exec=":kill" timeout_seconds="60" />
    <exec_method type="method" name="refresh" exec=":kill -HUP" timeout_seconds="60" />

    <property_group name="startd" type="framework">
      <propval name="duration" type="astring" value="child" />
      <propval name="ignore_error" type="astring" value="core,signal" />
    </property_group>

    <property_group name="application" type="application">
      <propval name="config_file" type="astring" value="/opt/local/etc/haproxy.cfg" />
    </property_group>

    <stability value="Evolving" />

    <template>
      <common_name>
        <loctext xml:lang="C">HAProxy</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```
