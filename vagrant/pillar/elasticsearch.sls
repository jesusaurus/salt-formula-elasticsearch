elasticsearch:
  cluster_name: 'notthedefaultcluster'
  publish_host: {{ salt['grains.get']('ip_interfaces:eth0')[0] }}
  cluster_hosts: "192.168.1.2, 192.168.2.3"
