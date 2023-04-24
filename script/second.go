package main

import (
	"fmt"
	"log"
	"os/exec"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ses"
)

func main() {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1"),
	})
	if err != nil {
		log.Fatal(err)
	}

	count, err := getRunningInstanceCount(sess)
	if err != nil {
		log.Fatal(err)
	}

	if count < 2 || count > 4 {
		err = sendEmailNotification(sess, count)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func getRunningInstanceCount(sess *session.Session) (int, error) {
	cmd := exec.Command("aws", "ec2", "describe-instances", "--filters", "Name=subnet-id,Values=SUBNET_ID", "Name=instance-state-name,Values=running", "--query", "length(Reservations[].Instances[])")
	out, err := cmd.Output()
	if err != nil {
		return 0, err
	}

	var count int
	_, err = fmt.Sscan(string(out), &count)
	if err != nil {
		return 0, err
	}

	return count, nil
}

func sendEmailNotification(sess *session.Session, count int) error {
	sesSvc := ses.New(sess)

	subject := "EC2 instance count alert"
	body := fmt.Sprintf("The current count of running EC2 instances in the private subnet is %d, which is outside the expected range of 2 to 4.", count)
	msg := &ses.Message{
		Subject: &ses.Content{
			Data: aws.String(subject),
		},
		Body: &ses.Body{
			Text: &ses.Content{
				Data: aws.String(body),
			},
		},
	}
	dest := &ses.Destination{
		ToAddresses: []*string{
			aws.String("aminkosari98@gmail.com"),
		},
	}
	input := &ses.SendEmailInput{
		Message:  msg,
		Destinations: []*string{
			dest.ToAddresses[0],
		},
		Source: aws.String("aws@turkey.com"),
	}

	// Send the email message
	_, err := sesSvc.SendEmail(input)
	if err != nil {
		return err
	}

	return nil
}