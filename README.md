# Creating an Nginx Website using Terraform and AWS

I will be using AWS for this lab. The AWS Region will be Ireland and EC2 instances are of type t2.micro. It should either cost nothing or very minimum depending  on Free Tier. This website consist of a  load balancer with two instances, the number of instances can be increased if desired to do so. I am using Terraform’s Local back-end with verifications of AWS done through environmental variable in my windows machine.


To format our code, validate our syntax and see our plan.

```
terraform fmt
terraform validate
terraform plan
```

![pic-2](/dubdub/pics/pic-2.png)


![pic-3](/dubdub/pics/pic-3.png)

Before applying any changes, my EC2 Dashboard showing zero for all running instances, ASG and Load Balancers.


![pic-1](/dubdub/pics/pic-1.png)

Lets apply our terraform. I am using  `-auto-approve` to not be prompted for approval.

```
terraform apply -auto-approve
```


![pic-4](/dubdub/pics/pic-4.png)

Seven resources in total have been added.

![pic-5](/dubdub/pics/pic-5.png)

My EC2 Dashboard has 2 instances as expected, 1 load balancer which is Application Load Balancer and 1 ASG.

![pic-6](/dubdub/pics/pic-6.png)

I will click on my load balancer in EC2 Dashboard, copy it’s DNS name and paste it in my internet browser. 

![pic-7](/dubdub/pics/pic-7.png)

![pic-8](/dubdub/pics/pic-8.png)

My website is up and running.

![pic-9](/dubdub/pics/pic-9.png)

Now it's time to tidy up.
```
terraform destroy -auto-approve
```

![pic-10](/dubdub/pics/pic-10.png)


