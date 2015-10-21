# Internal load balancing with HAProxy and Consul

## Build images
In this section you will build to GCE images: one for the HAProxy servers, and another for the private API/microservice. You're pre-building these images because the instances will be private, without public Internet connectivity, and can't be bootstrapped at launch time.

* Download [Packer](https://packer.io/)
*
* In your GCP project, navigate to **APIs & auth >> Credentials**, click **Add credentials**, then choose **Service account**. Select the **JSON** key type and click **Create** to download a credential file.
*
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

* cd to `images/api-internal/packer.json` and build the image for the internal API/microservice:

  ```
  $ packer build -var project_id=REPLACE_WITH_YOUR_PROJECT_ID packer.json
  ```

* cd to `images/haproxy/packer.json` and build the image for the internal HAProxy server:

  ```
  $ packer build -var project_id=REPLACE_WITH_YOUR_PROJECT_ID packer.json
  ```
