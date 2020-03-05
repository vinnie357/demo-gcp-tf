# issues/roadmap

## vm count
update bucket to find device by id
bucket storage of device IP for peering

dynamic outputs based on count
https://www.terraform.io/docs/configuration/expressions.html
for loop on gcp.firewall.count?

### running DO
update run DO to:
select by device id, odds are 01,evens are 02

if [ $((number%2)) -eq 0 ]
then
  echo "Number is even."
else
  echo "Number is odd."
fi

## ts
setup demo TS app
declaration

## GKS
setup app with tagging in google k8s

## cloud failover
setup cloud failover
tags
declaration

## FAST
add fast for managing AS3
https://github.com/f5devcentral/f5-appsvcs-templates

## failover options
large mutli nic ha with GLB ( less instances)
small single nic auto scale with GLB ( more instances)
large multi nic active active with dns ( global more small instances)
small multi nic active active with dns ( global more small instances)
large multi nic ha with Nginx autoscale ( less instances, more options for scale sni routing/certs)