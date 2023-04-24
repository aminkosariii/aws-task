package main

import (
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/ssm"
)

func main() {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1"),
	})
	if err != nil {
		log.Fatal(err)
	}
	installNginx(sess)
	configureNginx(sess)
	createAMI(sess)
}

func installNginx(sess *session.Session) {
	ssmSvc := ssm.New(sess)
	_, err := ssmSvc.SendCommand(&ssm.SendCommandInput{
		DocumentName: aws.String("AWS-RunShellScript"),
		InstanceIds:  []*string{aws.String("INSTANCE_ID")},
		Parameters: map[string][]*string{
			"commands": {
				aws.String("sudo yum update -y"),
				aws.String("sudo amazon-linux-extras install nginx1.12 -y"),
				aws.String("sudo systemctl start nginx"),
				aws.String("sudo systemctl enable nginx"),
			},
		},
	})
	if err != nil {
		log.Fatal(err)
	}
}

func configureNginx(sess *session.Session) {
	ssmSvc := ssm.New(sess)
	_, err := ssmSvc.SendCommand(&ssm.SendCommandInput{
		DocumentName: aws.String("AWS-RunShellScript"),
		InstanceIds:  []*string{aws.String("INSTANCE_ID")},
		Parameters: map[string][]*string{
			"commands": {
				aws.String("sudo echo 'server { listen 80; location / { return 200 \"Hello World!\"; } }' > /etc/nginx/conf.d/default.conf"),
				aws.String("sudo systemctl restart nginx"),
			},
		},
	})
	if err != nil {
		log.Fatal(err)
	}
}

func createAMI(sess *session.Session) {
	ec2Svc := ec2.New(sess)
	resp, err := ec2Svc.CreateImage(&ec2.CreateImageInput{
		InstanceId: aws.String("INSTANCE_ID"),
		Name:       aws.String("My AMI"),
		Description: aws.String("An AMI created from my EC2 instance"),
		NoReboot:   aws.Bool(true),
	})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Created AMI:", *resp.ImageId)
}