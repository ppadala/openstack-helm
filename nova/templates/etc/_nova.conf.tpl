# nova.conf
[DEFAULT]
debug = {{.Values.debug}}

log_config_append = /etc/nova/logging.conf

api_paste_config = /etc/nova/api-paste.ini
state_path = /var/lib/nova

security_group_api = neutron
network_api_class = nova.network.neutronv2.api.API
firewall_driver = nova.virt.firewall.NoopFirewallDriver

linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver

allow_resize_to_same_host = true
enabled_apis=osapi_compute,metadata

osapi_compute_workers=5


memcache_servers =  {{include "memcached_host" .}}:{{.Values.global.memcached_port_public}}

default_schedule_zone = {{.Values.global.default_availability_zone}}
default_availability_zone = {{.Values.global.default_availability_zone}}


[spice]

enabled = False
html5proxy_base_url = {{.Values.global.nova_console_endpoint_protocol}}://{{include "nova_console_endpoint_host_public" .}}:{{.Values.global.nova_spicehtml5_port_public}}/spice_auto.html
html5proxy_port = {{.Values.global.nova_spicehtml5_port_public}}

[vnc]
enabled = True
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = {{.Values.global.nova_console_endpoint_protocol}}://{{include "nova_console_endpoint_host_public" .}}:{{ .Values.global.nova_novnc_port_public }}/vnc_auto.html
novncproxy_host= 0.0.0.0
novncproxy_port = {{ .Values.global.nova_novnc_port_public}}





[oslo_messaging_rabbit]
rabbit_userid = {{ .Values.global.rabbitmq_default_user }}
rabbit_password = {{ .Values.global.rabbitmq_default_pass }}
rabbit_host =  {{include "rabbitmq_host" .}}
rabbit_ha_queues = true


[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[glance]
api_servers = {{.Values.global.glance_api_endpoint_protocol_internal}}://{{include "glance_api_endpoint_host_internal" .}}:{{.Values.global.glance_api_port_internal}}
num_retries = 10


[cinder]
os_region_name = {{.Values.global.region}}
catalog_info = volumev2:cinderv2:internalURL
cross_az_attach={{.Values.cross_az_attach}}

[neutron]
url = {{.Values.global.neutron_api_endpoint_protocol_internal}}://{{include "neutron_api_endpoint_host_internal" .}}:{{ .Values.global.neutron_api_port_internal }}
metadata_proxy_shared_secret = {{ .Values.global.nova_metadata_secret }}
service_metadata_proxy = true
auth_url = {{.Values.global.keystone_api_endpoint_protocol_admin}}://{{include "keystone_api_endpoint_host_admin" .}}:{{ .Values.global.keystone_api_port_admin }}/v3
auth_plugin = v3password
username = {{ .Values.global.neutron_service_user }}
password = {{ .Values.global.neutron_service_password }}
user_domain_name = {{.Values.global.keystone_service_domain}}
region_name = {{.Values.global.region}}
project_name = {{.Values.global.keystone_service_project}}
project_domain_name = {{.Values.global.keystone_service_domain}}

[api_database]
connection = postgresql://{{.Values.api_db_user}}:{{.Values.api_db_password}}@{{include "nova_db_host" .}}:{{.Values.global.postgres_port_public}}/{{.Values.api_db_name}}


[database]
connection = postgresql://{{.Values.db_user}}:{{.Values.db_password}}@{{include "nova_db_host" .}}:{{.Values.global.postgres_port_public}}/{{.Values.db_name}}


[keystone_authtoken]
auth_uri = {{.Values.global.keystone_api_endpoint_protocol_internal}}://{{include "keystone_api_endpoint_host_internal" .}}:{{ .Values.global.keystone_api_port_internal }}
auth_url = {{.Values.global.keystone_api_endpoint_protocol_admin}}://{{include "keystone_api_endpoint_host_admin" .}}:{{ .Values.global.keystone_api_port_admin }}/v3
auth_type = v3password
username = {{ .Values.global.nova_service_user }}
password = {{ .Values.global.nova_service_password }}
user_domain_name = {{.Values.global.keystone_service_domain}}
project_name = {{.Values.global.keystone_service_project}}
project_domain_name = {{.Values.global.keystone_service_domain}}
memcache_servers = {{include "memcached_host" .}}:{{.Values.global.memcached_port_public}}
insecure = True

#[upgrade_levels]
#compute = auto

[oslo_messaging_notifications]
driver = noop

[oslo_middleware]
enable_proxy_headers_parsing = true

[libvirt]
connection_uri = "qemu+tcp://127.0.0.1/system"
iscsi_use_multipath=True
#inject_key=True
#inject_password = True
#live_migration_downtime = 500
#live_migration_downtime_steps = 10
#live_migration_downtime_delay = 75
#live_migration_flag = VIR_MIGRATE_UNDEFINE_SOURCE, VIR_MIGRATE_PEER2PEER, VIR_MIGRATE_LIVE, VIR_MIGRATE_TUNNELLED

[ironic]
#TODO: this should be V3 also?

admin_username={{.Values.global.ironic_service_user }}
admin_password={{.Values.global.ironic_service_password }}
admin_url = {{.Values.global.keystone_api_endpoint_protocol_admin}}://{{include "keystone_api_endpoint_host_admin" .}}:{{ .Values.global.keystone_api_port_admin }}/v2.0
admin_tenant_name={{.Values.global.keystone_service_project}}
api_endpoint={{.Values.global.ironic_api_endpoint_protocol_internal}}://{{include "ironic_api_endpoint_host_internal" .}}:{{ .Values.global.ironic_api_port_internal }}/v1
