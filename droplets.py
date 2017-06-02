#!/usr/bin/env python

import json
import argparse
import subprocess


def main():
    inventory = {'client': {}, 'server': {}}
    hostvars = {}

    inventory['client']['hosts'] = ['client0', 'client1', 'client2', 'client3']
    inventory['server']['hosts'] = ['server0', 'server1', 'server2', 'server3']

    for type in ['client', 'server']:
        for h in inventory[type]['hosts']:
            address = subprocess.Popen("terraform output %s_public_ipv4" % h,
                                       shell=True, stdout=subprocess.PIPE)
            hostvars[h] = {'ansible_user': 'root',
                           'ansible_host': address.stdout.read().strip('\n')}

    # noqa https://github.com/ansible/ansible/commit/bcaa983c2f3ab684dca6c2c2c8d1997742260761
    inventory['_meta'] = {'hostvars': hostvars}

    parser = argparse.ArgumentParser(description="DO droplet inventory")
    parser.add_argument('--list', action='store_true',
                        help="List DO droplet inventory")
    parser.add_argument('--host', help='List details of a droplet')
    args = parser.parse_args()

    if args.list:
        print(json.dumps(inventory))
    elif args.host:
        print(json.dumps(hostvars.get(args.host, {})))


if __name__ == '__main__':
    main()
