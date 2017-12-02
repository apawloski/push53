### Push53 - Quick and Lazy Dynamic DNS

Push53 is tiny script which updates Route 53 records. It's intended for resources behind a domain name but with dynamic IP addresses. This typically applies to computers on your home network that you want to reach from the outside world.

_Note: Your domain must be maintained by Route 53 for this Route 53 script to be of any use to you._

#### Installation and Configuration

To install: `bundle install`

To run: `bundle exec ruby push53.rb $DOMAIN $HOSTED_ZONE_ID`

This script picks up your default AWS profile and credentials (usually stored ) in `~/.aws/config` and `~/.aws/credentials`

I recommend running it as a cron job. Here's a crontab that will run every 15 minutes:

`*/15 * * * * bundle exec ruby push53.rb $DOMAIN $HOSTED_ZONE_ID`

_Note: remember that cron might not run as the user you're expecting, which may mean the aws client won't find your credentials in its path. Either configure to run as the desired user, or make sure your desired profile is stored in the corrent path._

#### Least Privilege Recommendation

I recommend you use this utility with an IAM policy which only allows Route 53 change sets on your desired hosted zone. Here is a policy which will allow that:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::change/*",
                "arn:aws:route53:::hostedzone/ZPNHPW49N8WCE"
            ]
        }
    ]
}
