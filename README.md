# Solution

## Crud APP

1. A simple users CRUD app where users can be created, edited, viewed and deleted.
2. Written in Spring Boot
3. Backed by MySQL database
   
## Infra

1. Create AKS cluster using terraform.
2. Note: AZ cli installed and configured

3. ```bash
   $ cd infra
   $ terraform init
   $ terraform plan
   $ terraform apply
   ```
4. Get Resource Group Name
   `resource_group_name=$(terraform output -raw resource_group_name)`
5. Get Cluster Name
   
  ```bash
  $ az aks list \
  --resource-group $resource_group_name \
  --query "[].{\"K8s cluster name\":name}" \
  --output table
```

## Docker Build And Push

```bash
$ docker build <dockerhub_user>/usersapp:latest .
$ docker login -u <user>
$ docker push <dockerhub_user>/usersapp:latest .
```
## Manually Deploy to AKS

1. Note Kubectl Configured.
2. ```bash
   $ cd infra
   $ echo "$(terraform output kube_config)" > ./azurek8s
   $ export KUBECONFIG=./azurek8s
   $ kubectl get nodes
   $ cd ..
   $ kubectl apply -f ./k8s
   $ kubectl get all
   ```

## Configure Github Actions

1. ```bash
   $ az ad sp create-for-rbac \
    --name "ghActionAzureRbac" \
    --scope /subscriptions/a940bee1-b520-434a-85a4-ab091a8ddf1e/resourceGroups/rg-tender-lioness \
    --role Contributor \
    --sdk-auth
   ```
2. Get json output and add as Secret variable value AZURE_CREDS
3. Set DOCKERHUB_USER and DOCKERHUB_PASSWORD secrets

## Test

1. Get kubernetes loadbalancer IP `kubectl get service server-api`
2. Create User:
   
   ```bash
	$ curl -X POST \
	  http://20.231.239.89:8080/users \
	  -d '{
		"firstName": "test",
		"lastName": "test1234",
		"username": "testuser",
		"password": "testpassword",
		"salary": "10000",
		"age": "28"
	 	}'
  	```
   `
3. Get Users:
   ```bash
	$ curl -X GET \
	  http://20.231.239.89:8080/users
	```
4. Get User:
   ```bash
   $ curl -X GET \
	  http://20.231.239.89:8080/users/3
	  ```
5. Update User:
   ```bash
	$ curl -X PUT \
	  http://20.231.239.89:8080/users/3 \
	  -d '{
		"id": 3,
		"firstName": "test",
		"lastName": "test1234",
		"username": "testusernew",
		"password": "testpassword",
		"salary": "20000",
		"age": "29"
	}'
	```
7. Delete User:
  ```bash
	$ curl -X DELETE \
	  http://20.231.239.89:8080/users/4
```
