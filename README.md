# search_aws
Simple tool to easily search through AWS profiles for a particular resource (ec2 at the moment). Inspired by [Ivo Ursino's profile script](https://github.com/ivours/awsprofile)

## Usage

```
./aws_search.sh [profile] [criteria]

where [option]:
	--help
           Display this help.
               
	profile
           Either 'all', or the particular AWS profile/account you want to search against. When 'all' is selected, it will search through all your credentials stored in your `~/.aws/credentials` file.
                
	criteria
           Search criteria.
```
###Todo:
- Add options to search through other resources like RDS etc. At the moment this is limited to ec2
- Use --filters with the query instead of grep 

