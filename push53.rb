require 'aws-sdk'
require 'open-uri'

usage = "Usage: push53 domain_name hosted_zone_id"

if ARGV.length != 2
  puts usage
  exit 1
else
  domain = ARGV[0]
  zone = ARGV[1]
end

my_ip = open('http://whatismyip.akamai.com').read

route53 = Aws::Route53::Client.new
resp = route53.change_resource_record_sets({
      hosted_zone_id: zone,
      change_batch: {
        changes: [
          {
            action: "UPSERT",
            resource_record_set: {
              name: domain,
              resource_records: [
                {
                  value: my_ip,
                },
              ],
              ttl: 60,
              type: "A",
            },
          },
        ],
        comment: "Dynamically updated by push53 (github.com/apawloski/push53)",
      }
  })
route53.wait_until(:resource_record_sets_changed, {id: resp.change_info.id})
