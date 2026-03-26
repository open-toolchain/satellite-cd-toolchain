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
#### Satellite Deployment - Tekton Pipelines

This pipeline and relevant trigger(s) can be configured using the properties described below.

See https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-tekton-pipelines&interface=ui#configure_tekton_pipeline for more information.


**EventListeners:**

- [prod-deploy](#prod-deploy)
- [manual-run](#manual-run) - manual run listener
- [github-ent-commit](#github-ent-commit) - github enterprise commit push event listener
- [github-commit](#github-commit) - github commit push event listener
- [grit-or-gitlab-commit](#grit-or-gitlab-commit) - GRIT/gitlab commit push event listener
- [bitbucket-commit](#bitbucket-commit) - bitbucket commit push event listener

##### prod-deploy

**EventListener**: prod-deploy


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `cluster-namespace` | - | - | Yes | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |


##### manual-run

**EventListener**: manual-run - manual run listener


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `cluster-namespace` | - | - | Yes | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |


##### github-ent-commit

**EventListener**: github-ent-commit - github enterprise commit push event listener


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `branch` | - | `$(event.ref)` | No | string |
| `cluster-namespace` | - | - | Yes | string |
| `commit-id` | - | `$(event.after)` | No | string |
| `commit-timestamp` | - | `$(event.repository.pushed_at)` | No | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `repository` | - | `$(event.repository.html_url)` | No | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `scm-type` | - | `github-ent` | No | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |


##### github-commit

**EventListener**: github-commit - github commit push event listener


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `branch` | - | `$(event.ref)` | No | string |
| `cluster-namespace` | - | - | Yes | string |
| `commit-id` | - | `$(event.after)` | No | string |
| `commit-timestamp` | - | `$(event.repository.updated_at)` | No | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `repository` | - | `$(event.repository.html_url)` | No | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `scm-type` | - | `github` | No | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |


##### grit-or-gitlab-commit

**EventListener**: grit-or-gitlab-commit - GRIT/gitlab commit push event listener


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `branch` | - | `$(event.ref)` | No | string |
| `cluster-namespace` | - | - | Yes | string |
| `commit-id` | - | `$(event.checkout_sha)` | No | string |
| `commit-timestamp` | - | `$(event.commits[0].timestamp)` | No | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `repository` | - | `$(event.project.http_url)` | No | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `scm-type` | - | `gitlab` | No | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |


##### bitbucket-commit

**EventListener**: bitbucket-commit - bitbucket commit push event listener


| Properties | Description | Default | Required | Type |
|------------|-------------|---------|----------|------|
| `api` | the IBM Cloud api endpoint | `https://cloud.ibm.com` | No | string |
| `apikey` | - | - | Yes | string |
| `apikey` (**secured property**) | [IBM Cloud Api Key](https://cloud.ibm.com/iam/apikeys) used to access to the toolchain (and git intergation toolcard like `Git Repos and Issue Tracking` service if used). | - | Yes | secret |
| `branch` | - | `$(event.push.changes[0].new.name)` | No | string |
| `cluster-namespace` | - | - | Yes | string |
| `commit-id` | - | `$(event.pull_request.head.sha)` | No | string |
| `commit-timestamp` | - | `$(event.pull_request.head.repo.pushed_at)` | No | string |
| `commons-hosted-region` | - | `https://raw.githubusercontent.com/open-toolchain/commons/master` | No | string |
| `configuration-name` | configuration-name | - | Yes | string |
| `deployment-branch` | the branch for the git repo | `master` | No | string |
| `deployment-file` | file containing the kubernetes deployment definition | - | Yes | string |
| `directory-path` | directory where deployment files are located | - | Yes | string |
| `git-token` | access token for the git repo | `` | No | string |
| `pipeline-debug` | Pipeline debug mode. Value can be 0 or 1. | `0` | No | string |
| `pipeline-name` | - | - | Yes | string |
| `repository` | - | `$(event.repository.links.html.href)` | No | string |
| `revision` | - | `$(event.push.changes[0].new.target.hash)` | No | string |
| `satellite-cluster-group` | Satelite Cluster Group | - | Yes | string |
| `scm-type` | - | `bitbucket` | No | string |
| `source-repo` | The variable storing git integration for the repository storing build deployment files. | - | Yes | string |
| `toolchain-apikey` | - | - | Yes | string |

#### Satellite Deployment - Tekton Task(s)
- **[execute-on-satelite](#execute-on-satelite)**: 

##### execute-on-satelite

execute-on-satelite task

###### Context - ConfigMap/Secret

  The task may rely on the following kubernetes resources to be defined:

* **Secret secure-properties**
  name of the configmap containing the continuous delivery pipeline context secrets

  Secret containing:
  * **apikey**: field in the secret that contains the api key used to login to ibmcloud kubernetes service

Note: secret name and secret key(s) can be configured using Task's params.
###### Parameters

* **ibmcloud-api**: the ibmcloud api (default to `https://cloud.ibm.com`)
* **continuous-delivery-context-secret**: name of the configmap containing the continuous delivery pipeline context secrets (default to `secure-properties`)
* **kubernetes-service-apikey-secret-key**: field in the secret that contains the api key used to login to ibmcloud kubernetes service (default to `apikey`)
* **resource-group**: target resource group (name or id) for the ibmcloud login operation (default to empty string)
* **directory-path** **[required]**: 
* **image-url**: URL of an image that is relevant to the deployment action (default to empty string)
* **shuttle-properties-file**: name of the properties file that contain properties to include in the environment for the `cf-commands` snippet/script execution (default to empty string)
* **setup-script**: script that typically set up environment before the _deployment_ script execution. (default to empty string)
* **script**: _deployment_ script to be executed (default to empty string)
* **post-execution-script**: script that get executed after the _deployment_ script has been executed. (default to empty string)
* **pipeline-debug**: Pipeline debug mode. Value can be 0 or 1. Default to 0 (default to `0`)

###### Workspaces

* **artifacts**: A workspace
