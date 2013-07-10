
Based on Sendgrid DNS validation rules to configure new subuser accounts

Run: ruby emails.rb

First entry: domain name e.g. mydomain.com
Second entry: subdomain used for Sendgrid e.g. email (if email.mydomain.com was used)

Any error causes the DNS query to be displayed. It is best to do further troubleshooting directly with dig.