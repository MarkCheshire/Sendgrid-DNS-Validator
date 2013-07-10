require 'dnsruby'
include Dnsruby
# require 'pry'
# require 'pry-debugger'


def email_error (msg, dns_response)
  puts msg
  puts dns_response
  puts "================="
end

def test_email_record (domain, dns_record, validation_query, ok_msg, error_msg)
  res=Resolver.new
  r=res.query(domain, dns_record)
  if r.to_s =~ validation_query
# binding.pry
    puts ok_msg
  else
# binding.pry
    email_error error_msg, r
  end
rescue
  email_error error_msg, r
end

puts "Welcome to the 3scale Email checker"
puts "==================================="
puts
print "Enter the top level customer domain (e.g. example.com): "
customer_domain = gets.chomp
print "Enter the email subdomain (e.g. apimail): "
email_subdomain = gets.chomp

test_email_record(
        "#{email_subdomain}.#{customer_domain}",
        "CNAME",
        /sendgrid\.net\.$/,
        "CNAME fine",
        "CNAME is missing 'sendgrid.net'")

test_email_record(
        "#{customer_domain}",
        "TXT",
        /v=spf1 .*include:sendgrid.net.* ~all/,
        "SPF fine",
        "SPF is missing 'include:sendgrid.net.* ~all'")

test_email_record(
        "smtpapi\._domainkey.#{customer_domain}",
        "CNAME",
        /dkim\.sendgrid\.net\.$/,
        "Domainkey 1 fine",
        "Domainkey 'smtpapi._domainkey.#{customer_domain}' incorrect")

test_email_record(
        "smtpapi._domainkey.#{email_subdomain}.#{customer_domain}",
        "CNAME",
        /dkim\.sendgrid\.net\.$/,
        "Domainkey 2 fine",
        "Domainkey 'smtpapi._domainkey.#{email_subdomain}.#{customer_domain}' incorrect")

test_email_record(
        "o1.#{email_subdomain}.#{customer_domain}",
        "A",
        /75\.126\.253\.120/,
        "A record fine",
        "A record should point to 75.126.253.120")

