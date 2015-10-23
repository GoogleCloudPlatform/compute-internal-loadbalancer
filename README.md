# Internal load balancing with HAProxy and Consul
This sample deploys a complete multi-tier sample application. The basic architecture is:

```
-----------      ------------      ~~~~~~~~~~~~     -----------       -----------
|         |      |          |      |          |     |         |       |         |
|  user   | ---> |Public LB | ---> | Frontend | --> | HAProxy |-----> | Backend |
|(browser)|      |          |      | Microsvc |     |(Priv IP)|  |    |Microsvc |
|         |      |          |      | (Pub IP) |     |         |  |    |(Priv IP)|
-----------      ------------      ~~~~~~~~~~~~     -----------  |    -----------
                                                                 |    -----------
                                                                 |    |         |
                                                                 |--> | Backend |
                                                                      |Microsvc |
                                                                      |(Priv IP)|
                                                                      -----------
```

The stack is run in two availability zones. A Consul master is also run in each zone. The backend app/microsrvice servers register themselves as a service with Consul. HAProxy servers discover the instances in this service and update their haproxy.cfg templates as membership changes (using `consul-template`). Multiple HAProxy servers run in each zone, and also register themselves as a service with Consul. The frontend app/microservice has `dnsmasq` installed, which forwards DNS requests to Consul's DNS. This allows name-based discovery of the HAProxy servers in each zone.

In the following section you will build a custom image for the backend and HAProxy instances. Look at the `packer.json` file for each for details on how the images are configured.

## Build images
In this section you will build two GCE images: one for the HAProxy servers, and another for the private API/microservice. You're pre-building these images because the instances will be private, without public Internet connectivity, and can't be bootstrapped at launch time.

* Download [Packer](https://packer.io/)

* Create a new Google Cloud Platform project and enable the `Google Compute Engine` and `Cloud Deployment Manager` APIs

* In your GCP project, navigate to **APIs & auth >> Credentials**, click **Add credentials**, then choose **Service account**. Select the **JSON** key type and click **Create** to download a credential file.

* Edit both `images/api-internal/packer.json` and `images/haproxy/packer.json`, setting the `account_file` property to the fully qualified path of the key file you downloaded in the previous step. For example:

  ```
  {
    "variables": {
      "account_file": "/home/evanbrown/key.json",
      ...
    },
    ...
  }
  ```

* cd to `images/api-internal` and build the image for the internal API/microservice:

  ```
  $ packer build -var project_id=REPLACE_WITH_YOUR_PROJECT_ID packer.json
  ```

* cd to `images/haproxy` and build the image for the internal HAProxy server:

  ```
  $ packer build -var project_id=REPLACE_WITH_YOUR_PROJECT_ID packer.json
  ```

* Run `gcloud compute images list --no-standard-images` and note the name of each of the images you created in the above steps.

## Deploy
* Open `config.yaml` in the root of this repo and replace the `PROJECT_NAME` and `IMAGE_NAME` strings in the `haproxy_image` and `internal_api_image` properties

* Deploy the infrastructure:

 ```
 $ gcloud deployment-manager deployments create ilb-demo --config=config.yaml
 ```

 * When the deployment completes, open the **HTTP load balancing** section of the console and open the IP address of the load balancer create by the deployment.

 ## Delete
 When you are done, either delete your project or delete the deployment with `gcloud deployment-manager deployments delete ilb-demo`
