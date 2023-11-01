#!/usr/bin/python3
"""
This script launches a new infinity portal account and s1c tenant
"""

import json, logging, argparse, requests

logging.basicConfig(level=logging.WARNING)
log = logging.getLogger(__name__)

def login():
  parser = argparse.ArgumentParser()
#  parser.add_argument("command", help="""
#                      The commands are listed in the swagger
#                      https://app.swaggerhub.com/apis-docs/Check-Point/smart-1_cloud_api/1.0.0#/Authentication/getAuthToken
#                      """)
  parser.add_argument("-cid", "--client-id", required=True)
  parser.add_argument("-ak", "--access-key", required=True)
  parser.add_argument("-gn", "--Gateway-name")
  parsed_args = parser.parse_args()

  URL = "https://cloudinfra-gw.portal.checkpoint.com"
  authapikey =f"{URL}/auth/external"

  headers = {
  'Content-Type': 'application/json'
  }

  payload = json.dumps(
    {
      "clientId": parsed_args.client_id,
      "accessKey": parsed_args.access_key
    })

  respone = requests.request("POST", authapikey, headers=headers, data=payload)

  token = respone.json()['data']['token']

  print(token)

def tenant():

  headers = {
    'Content-type': 'application/json',
    'Authorizaton': f'Berer {token}'
  }

def main():
  login()

if __name__ == '__main__':
  main()
