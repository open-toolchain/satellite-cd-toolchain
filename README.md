# Deploy to Satellite

## Introduction 

 [IBM Cloud Satellite](https://www.ibm.com/cloud/satellite) is an extension of the IBM Public Cloud that can run inside the customer's data center or out at the edge. Each Cloud Satellite location is connected using  IBM Cloud Satellite Link which provides the connection to the IBM Cloud control plane. It provides audit, packet capture, and visibility to the security team, while a configuration utility provides a global view of applications and services.  IBM Cloud Satellite Link provides a simple way to manage the connection between IBM Cloud and the satellite location with visibility into all the traffic going back and forth with control over what endpoints on both sides of the link.
 
Users can have groups of clusters (either IBM Kubernetes Services or RedHat OpenShift) in a [Satellite cluster group](https://cloud.ibm.com/docs/satellite?topic=satellite-setup-clusters-satconfig). [Satellite Config](https://cloud.ibm.com/docs/satellite?topic=satellite-cluster-config) can be used to deploy the application into a [Satellite cluster group](https://cloud.ibm.com/docs/satellite?topic=satellite-setup-clusters-satconfig).
The Secure App toolchain provides a quick start toolchain which can be used as a reference implementation to deploy your application on Satellite. 
 
The scope of this documentation is limited to the introduction and prerequistes required for the toolchain. It also explains what the associated pipeline does during a deployment run.
 
 

## Prerequisite 

* This toolchain uses [Satellite Config](https://cloud.ibm.com/docs/satellite?topic=satellite-cluster-config) for deploying an application to a group of clusters. 
* This toolchain assumes that you have a [Satellite cluster group](https://cloud.ibm.com/docs/satellite?topic=satellite-setup-clusters-satconfig) with the required clusters. 
* This toolchain supports a Satellite Cluster Group that contains only one type of cluster (either IBM Kubernetes Cluster or RedHat OpenShift).

## Deployment Strategy

A [Rolling](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/) strategy will be used for deploying changes to the satellite environment. [Satellite Config](https://cloud.ibm.com/docs/satellite?topic=satellite-cluster-config) will be used to deploy the application on the selected 
[Satellite cluster group](https://cloud.ibm.com/docs/satellite?topic=satellite-setup-clusters-satconfig).


##### The following are the steps that will be performed by the toolchain while performing deployment on satellite.


```
1. Toolchain will update the deployment file with the application image name obtained from the inventory repo.
2. Toolchain will update the deployment file with default ingress.
3. Check if the satellite cluster group has a cluster of type OpenShift, if true then update the deployment file with a default route.
4. Check if the satellite cluster group contains clusters of only one type (all IBM Kubernetes Cluster or all RedHat OpenShift). If not, then output an error.
5. Prepare the Satellite Config for kubernetes namespace and create the satellite subcription.
6. Prepare the Satellite Config for kubernetes service account and create the satellite subcription.
7. Prepare the Satellite Config for kubernetes application deployment and create the satellite subcription.
8. Check the application rollout status.
```






