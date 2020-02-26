#!/usr/bin/env bash
# Debug options:
#exec 1>./search_aws.log 2>&1
#set -euvo pipefail
#
# USAGE: ./search_aws.sh [awsprofile] [search criteria]
# i.e. /search_aws.sh prod 'instance name'

awsprofile=$1
criteria=$2

# Exit codes from <sysexits.h>
EX_TEMPFAIL=75
EX_UNAVAILABLE=69

# Clean up when done or when aborting.
trap "unset AWS_PROFILE && exit $?" 0 1 2 3 15

# Search function. Here I would like to add options to search RDS etc.
search(){
aws ec2 describe-instances --output table --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value,InstanceId,PrivateIpAddress,PublicIpAddress,State.Name,KeyName]' | grep -i $criteria
#aws ec2 describe-internet-gateways
#aws ec2 describe-subnets
#aws ec2 describe-route-tables
#aws ec2 describe-network-acls
#aws ec2 describe-vpc-peering-connections
#aws ec2 describe-vpc-endpoints
#aws ec2 describe-nat-gateways
#aws ec2 describe-security-groups
#aws ec2 describe-instances
#aws ec2 describe-vpn-connections
#aws ec2 describe-vpn-gateways
#aws ec2 describe-network-interfaces
}

#Help function to display usage message
helpme()
{
cat <<-END
                Missing option!
                Usage:
                ------
                   ./aws_search.sh [profile] [criteria]

                where [option]:
                --help
                   Display this help
                
                profile
                   Either 'all' or the particular AWS profile/account you want to search against
                
                criteria
                   Search criteria
END
exit 0            
}

# Check if values are empty to display help
if [ ! -z "$awsprofile" ] && [ ! -z "$criteria" ]
then
{
case $awsprofile in
		all)
		  
			# Get list of AWS profiles
			AWS_PROFILES=$(cat ~/.aws/credentials | grep '\[*\]' | cut -d "[" -f2 | cut -d "]" -f1)
			printf "\nSearching all environments...Ctrl + C to quit.\n"
		        
			echo "$AWS_PROFILES" | while read -r aws_profile_line ; do
				printf "\nSearching $aws_profile_line...\n"
				export AWS_PROFILE=$aws_profile_line
				search
				printf "\n=====\n"
				unset AWS_PROFILE
			done
		;;
		*)
			printf "\nSearching $awsprofile environment...\n"
			export AWS_PROFILE=$awsprofile
			search
			printf "\n=====\n"
		;;
esac
}
else
helpme
fi
printf "\nDone..\n\n"
