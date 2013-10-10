elasticsearch:
# use eth1, as under vagrant private network or public network, eth1 is the useful interface
  publish_host: {{ salt['grains.get']('ip_interfaces:eth1')[0] }}
  cluster_name: randomname
  cluster_nodes: es01,es02
